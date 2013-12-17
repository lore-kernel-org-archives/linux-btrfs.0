Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:49020 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751088Ab3LQB2j (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 16 Dec 2013 20:28:39 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gcfb-btrfs-devel-moved1@m.gmane.org>)
	id 1VsjSe-0004mb-Gx
	for linux-btrfs@vger.kernel.org; Tue, 17 Dec 2013 02:28:36 +0100
Received: from md5i.com ([75.151.244.229])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Dec 2013 02:28:36 +0100
Received: from mwd by md5i.com with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-btrfs@vger.kernel.org>; Tue, 17 Dec 2013 02:28:36 +0100
To: linux-btrfs@vger.kernel.org
From: Michael Welsh Duggan <mwd@md5i.com>
Subject: Re: btrfs send in 3.12 : can't find snapshot?
Date: Mon, 16 Dec 2013 20:28:27 -0500
Message-ID: <87ppowqn9g.fsf@maru2.md5i.com>
References: <87y53lqx88.fsf@maru2.md5i.com>
	<4231AC1F-47B3-441B-B56D-53462F4FEF38@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Wang Shilong <wangshilong1991@gmail.com> writes:

> Hello Michael,
>
>> I built the new btrfs-progs 3.12 recently.  I note that the version
>> information doesn't seem to match this:
>> 
>>    # ./btrfs --version
>>    Btrfs v0.20-rc1-358-g194aa4a
>> 
>> Regardless, I was trying to use btrfs send (which worked in the older
>> btrfs), and failed.  Here's an example:
>> 
>>    # ./btrfs send -vvv -p /snapshots/bo /snapshots/bp  > /dev/null
>>    At subvol /snapshots/bp
>>    ERROR: open @/snapshots/bp failed. No such file or directory
>> 
>> Any idea what might be going on here?
>> 
>> Here's the volume information:
>> 
>>    # ./btrfs sub show /
>>    /
>>            Name:                   @
>>            uuid:                   e5e505d6-1309-8447-b51e-73f08c9401d1
>>            Parent uuid:            156f93b9-1175-dc42-a1ee-65c00c5dcc2a
>>            Creation time:          2013-07-17 20:44:46
>>            Object ID:              259
>>            Generation (Gen):       296321
>>            Gen at creation:        20
>>            Parent:                 5
>>            Top Level:              5
>>            Flags:                  -
>>            Snapshot(s):
>>                                    snapshots/bo
>>                                    snapshots/bp
>> 
>> Kernel information:
>
> Here it seemed that you changed your default sub-volume.(259 not 5)
> I sent a patch before to fix this problem, it has not been pushed into
> chris's master branch, patch url is:
>
> https://patchwork.kernel.org/patch/3258971/
>
> But is has been pushed into david's latest integration branch , you
> can pull from:
>
> git pull http://github.com/kdave/btrfs-progs.git integration-20131211

After compiling this version the above tests works.  Now, however, the
receive fails:

    # ./btrfs send -p /snapshots/bo /snapshots/bp | ./btrfs receive /backup/snapshots/root/
    At subvol /snapshots/bp
    At snapshot bp
    ioctl(BTRFS_IOC_TREE_SEARCH, uuid, key 48f0ebae83fd32f1, UUID_KEY, 90139d8200afeaab) ret=-1, error: No such file or directory
    ioctl(BTRFS_IOC_TREE_SEARCH, uuid, key 48f0ebae83fd32f1, UUID_KEY, 90139d8200afeaab) ret=-1, error: No such file or directory
    ERROR: could not find parent subvolume

More volume information:

# ./btrfs sub show /backup/snapshots/root/bo
/backup/snapshots/root/bo
        Name:                   bo
        uuid:                   5e15ef24-f2d0-194f-886d-3f7afc7413a4
        Parent uuid:            9a226af3-8497-744b-90f7-d7e54d58946d
        Creation time:          2013-12-13 17:51:57
        Object ID:              1030
        Generation (Gen):       1046
        Gen at creation:        1042
        Parent:                 5
        Top Level:              5
        Flags:                  readonly
        Snapshot(s):
# ./btrfs sub show /snapshots/bo
/snapshots/bo
        Name:                   bo
        uuid:                   f132fd83-aeeb-f048-abea-af00829d1390
        Parent uuid:            e5e505d6-1309-8447-b51e-73f08c9401d1
        Creation time:          2013-12-13 17:50:15
        Object ID:              404
        Generation (Gen):       296977
        Gen at creation:        291623
        Parent:                 259
        Top Level:              259
        Flags:                  readonly
        Snapshot(s):
# ./btrfs sub show /snapshots/bp
/snapshots/bp
        Name:                   bp
        uuid:                   6f73d3f2-5f9b-4944-b2d2-3003331b2d10
        Parent uuid:            e5e505d6-1309-8447-b51e-73f08c9401d1
        Creation time:          2013-12-15 22:24:57
        Object ID:              405
        Generation (Gen):       296977
        Gen at creation:        296301
        Parent:                 259
        Top Level:              259
        Flags:                  readonly
        Snapshot(s):


-- 
Michael Welsh Duggan
(md5i@md5i.com)

