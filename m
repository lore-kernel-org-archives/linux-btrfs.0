From: miyamoto moesasji <miyamoto.31b@gmail.com>
Subject: Re: Unexpected ENOSPC on a SSD-drive after day of uptime,
	kernel?2.6.32-rc5
Date: Thu, 5 Nov 2009 22:37:10 +0000
Message-ID: <fe72f2c80911051437u4c79ff74nc7cd2c2ff8d45138@mail.gmail.com>
References: <fe72f2c80911051238y299bab12g5f4b878851a25f13@mail.gmail.com>
	 <20091105210234.GD22737@dhcp231-156.rdu.redhat.com>
	 <loom.20091105T214826-537@post.gmane.org>
	 <20091105215524.GA13953@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <20091105215524.GA13953@localhost.localdomain>
List-ID: <linux-btrfs.vger.kernel.org>

1) Running btrfs-vol -b indeed does free up some space on the
completely full partition, but not much, just 1GB. However I can use
it again, so that is very helpful. Many thanks Josef!

For completeness: After running it on sda5 and sda3:
Label: none  uuid: a12ac0e9-cbea-4acf-bb26-181146940714
        Total devices 1 FS bytes used 90.31MB
        devid    1 size 8.00GB used 6.42GB path /dev/sda5

Label: none  uuid: 0a89100d-096d-4c67-b3c7-745c9b7c3dc5
        Total devices 1 FS bytes used 10.60GB
        devid    1 size 20.00GB used 18.99GB path /dev/sda3

2) However I would still like to point out that I find it very
surprising to see the amount of space taken up by data+meta-data,
which looks dangerous to me seeing how quickly I got into a disk full
situation while normal df indicated no problem whatsoever (if on root
I would basically have had a kernel panic). Is this really expected
behavior or is this a known problem already so no need to
trouble-shoot?

On 11/5/09, Josef Bacik <josef@redhat.com> wrote:
> On Thu, Nov 05, 2009 at 08:55:12PM +0000, miyamoto moesasji wrote:
>>
>> > Hmm looks like quite a bit of your fs got taken up for metadata.
>> > Perhaps try
>> > running btrfsctl -b /usr and see if that frees up some space for you.
>> Thanks,
>>
>> 1) The btrfsctl does not have the -b option on my system, is that an
>> option
>> that only is only enabled with the debug-utilities?
>>
>
> Sorry I always get that wrong, its btrfs-vol -b.
>
>> 2) I would find it surprising if it is meta-data just looking at the
>> numbers.
>> Below is the output of btrfs-show for all partitions with btrfs.
>>
>> Label: none  uuid: a12ac0e9-cbea-4acf-bb26-181146940714
>>         Total devices 1 FS bytes used 89.53MB
>>         devid    1 size 8.00GB used 5.63GB path /dev/sda5
>>
>> Label: none  uuid: 59997df9-c5a3-431f-b0a0-95b9e3b1afff
>>         Total devices 1 FS bytes used 150.14MB
>>         devid    1 size 4.00GB used 2.04GB path /dev/sda2
>>
>> Label: none  uuid: 558766bb-5e0d-48dd-9a13-7117f3047710
>>         Total devices 1 FS bytes used 180.94MB
>>         devid    1 size 20.00GB used 5.04GB path /dev/sda6
>>
>> Label: none  uuid: 0a89100d-096d-4c67-b3c7-745c9b7c3dc5
>>         Total devices 1 FS bytes used 10.60GB
>>         devid    1 size 20.00GB used 20.00GB path /dev/sda3
>>
>> Label: none  uuid: 3cac73e5-e998-49bf-b8ee-ba953c92bc0b
>>         Total devices 1 FS bytes used 28.00KB
>>         devid    1 size 32.00GB used 2.04GB path /dev/sdb2
>>
>> As an example the /var (dev/sda5) has only 89MB in use, while btrfs-show
>> demonstrates 5.63GB being used of the 8GB. It almost looks as if files
>> that are
>> overwritten don't get removed from the space being in use.
>>
>
> The used part is how much of the volume is allocated into chunks.  So when
> it
> says 5.63 gb is being used, that means that 5.63 gbs of the volume has been
> carved up into data/metadata chunks.  I hope to at some point make one of
> our
> utilities tell you how much of that is for data and how much of that is
> metadata.  Thanks,
>
> Josef
>
