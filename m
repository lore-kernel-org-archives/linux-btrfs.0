Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.162]:19462 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750961Ab3GBMFT (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Tue, 2 Jul 2013 08:05:19 -0400
Message-ID: <51D2C1FD.5030405@giantdisaster.de>
Date: Tue, 02 Jul 2013 14:05:17 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: =?UTF-8?B?TWlndWVsIE5lZ3LDo28=?=
	<miguel.negrao-lists@friendlyvirus.org>
CC: btrfs list <linux-btrfs@vger.kernel.org>
Subject: Re: btrfs send /receive : having problems sending a snapshot back
 to the original partition
References: <1372612472.13762.18.camel@miguel-MacBookPro>  <51D1A529.4040109@giantdisaster.de> <1372758978.7295.17.camel@miguel-MacBookPro>
In-Reply-To: <1372758978.7295.17.camel@miguel-MacBookPro>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, 02 Jul 2013 10:56:18 +0100, Miguel Negrão wrote:
> Seg, 2013-07-01 às 17:50 +0200, Stefan Behrens escreveu:
>> What you are trying to do is not possible, it is not supported.
>>
>> Btrfs send/receive can be used to create backups. The use case to
>> restore from backups is not addressed.
>>
> Ok, I see, but then I think I don't understand how btrfs send receive is
> working. Is it the case that the parent 'a' in 'btrfs send -p a b' has
> to be an "older" version of 'b' and never the other way around, perhaps
> in the sense of a having a lower transid as returned by sudo btrfs
> subvolume find-new a 999999999999999 ? 
> 
> I tried doing  'btrfs send -p original a' then 'btrfs send -p a b', then
> deleting 'a' in the second disk and then doing 'btrfs send -p b a' but
> that also fails [1], the error happening on the receive side.

>  1999  touch /tmp/aaa.txt
>  2003  sudo btrfs subvolume snapshot -r /mnt/@ @-1
>  2004  touch /tmp/bbb.txt
>  2005  sudo btrfs subvolume snapshot -r /mnt/@ @-2
>  2007  sudo btrfs send -p @-2013-07-02-08\:03 @-1 | pv | sudo btrfs
> receive /media/miguel/huge/backups/@
>  2008  sudo btrfs send -p @-1 @-2 | pv | sudo btrfs
> receive /media/miguel/huge/backups/@
>  2010  btrdelete /media/miguel/huge/backups/@/@-1
>  2011  sudo btrfs send -p @-2 @-1 | pv | sudo btrfs
> receive /media/miguel/huge/backups/@
>
> error:
>
> At snapshot @-1
> ERROR: failed to clone extents to var/log/syslog
> Invalid argument

Well, the issue from this mail is not related to the issue from your previous mail. The "ERROR: failed to clone extents to var/log/syslog Invalid argument" is a bug in the send code. The Btrfs receive side by design is more or less stupid and is only executing the sequence of instructions that the send side has generated (try "-vv" in the receiver to dump the sequence), therefore the bug is in the sending side.


Back to your initial question and to the issue from your previous mail. You should be able to do a 'send -p a b' no matter how the relation between a and b is. a may be older than b, or b may be older than a, both should work.

The reason why you are not able to send an incremental snapshot back (as you tried it in your previous mail) is that the implementation cannot handle it. The receive side gets a parent_uuid (in case of incremental transfers using the "-p" option), this parent_uuid is matched to the fields received_uuid of the subvolumes in the receive filesystem. If no match is found, the receive fails. And that is what happens.

If you look at the following script, you can see the expected parent_uuid in the line before the "ERROR: could not find parent subvolume". And when you look at the output of "btrfs subv list ... /mnt/a", you notice that no subvolume at all has the field ruuid (which stands for received_uuid) set to any valid value. Therefore it doesn't match, therefore it fails.

This logic could be changed, but that's how it is today.


# mkfs.btrfs /dev/sdy; mkfs.btrfs /dev/sdz
# mkdir /mnt/{a,b}
# mount /dev/sdy /mnt/a; mount /dev/sdz /mnt/b
# btrfs subv create /mnt/a/subv
Create subvolume '/mnt/a/subv'
# cp /etc/motd /mnt/a/subv/.
# btrfs subv snap -r /mnt/a/subv /mnt/a/snap.1
Create a readonly snapshot of '/mnt/a/subv' in '/mnt/a/snap.1'
# cat /etc/motd >> /mnt/a/subv/motd
# btrfs subv snap -r /mnt/a/subv /mnt/a/snap.2
Create a readonly snapshot of '/mnt/a/subv' in '/mnt/a/snap.2'
# btrfs send /mnt/a/snap.1 | btrfs receive /mnt/b
At subvol /mnt/a/snap.1
At subvol snap.1
# btrfs send -p /mnt/a/snap.1 /mnt/a/snap.2 | btrfs receive /mnt/b
At subvol /mnt/a/snap.2
At snapshot snap.2
# btrfs subv list --fields=rootid,uuid,puuid,ruuid,path /mnt/a
ID 257 uuid c0e1a79b-cdcd-0347-929b-967b5b711932 puuid - ruuid - path subv
ID 258 uuid 3b8a3aec-a3d1-8941-88c5-dc3051b16b55 puuid c0e1a79b-cdcd-0347-929b-967b5b711932 ruuid - path snap.1
ID 259 uuid e34b0b31-95a2-6142-9058-4bf717fdb5d9 puuid c0e1a79b-cdcd-0347-929b-967b5b711932 ruuid - path snap.2
--- ^^^ no ruuid at all is set in the /mnt/a filesystem
# btrfs subv del /mnt/a/snap.2
Delete subvolume '/mnt/a/snap.2'
# btrfs send -p /mnt/b/snap.1 /mnt/b/snap.2 | btrfs receive -vv /mnt/a
At subvol /mnt/b/snap.2
At snapshot snap.2
receiving snapshot snap.2 uuid=288f88ec-9915-2a48-8722-a1e163a0cf2f, ctransid=12 parent_uuid=fa82938d-b73f-3349-b264-c3ebfcadde9f, parent_ctransid=9
ERROR: could not find parent subvolume
--- ^^^ the parent_uuid does not match to any ruuid on /mnt/a
# btrfs subv list --fields=rootid,uuid,puuid,ruuid,path /mnt/b
ID 257 uuid fa82938d-b73f-3349-b264-c3ebfcadde9f puuid - ruuid 3b8a3aec-a3d1-8941-88c5-dc3051b16b55 path snap.1
ID 258 uuid 288f88ec-9915-2a48-8722-a1e163a0cf2f puuid fa82938d-b73f-3349-b264-c3ebfcadde9f ruuid e34b0b31-95a2-6142-9058-4bf717fdb5d9 path snap.2

