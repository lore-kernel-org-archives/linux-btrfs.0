Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:19655 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753868AbaFICRW (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Sun, 8 Jun 2014 22:17:22 -0400
Message-ID: <539519BC.7060109@oracle.com>
Date: Mon, 09 Jun 2014 10:19:40 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, linux-btrfs@vger.kernel.org
CC: dsterba@suse.cz, wangsl.fnst@cn.fujitsu.com, clm@fb.com, jbacik@fb.com
Subject: Re: [PATCH V3] Btrfs: device_list_add() should not update list when
 mounted
References: <1402025201-17140-1-git-send-email-anand.jain@oracle.com> <53951371.9010608@cn.fujitsu.com>
In-Reply-To: <53951371.9010608@cn.fujitsu.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


Hi Qu,

> Thanks for your patch.
>
> The patch works fine,



> but unfortunately the solution seems not so generic.
> The patch just avoid the dirty work to distinguish devices with same uuid,
> This will fix the bug with dev scan, but when you umount the fs and
> mount it again, it will use the old device again, since device_list_add()
 > still can't distinguish different devices with same dev uuid.

  As mentioned in the other thread.. we expect user to check the devices
  before / after mount and wipefs the disks which should not belong to
  the fsid. as below.

----------------
  Yes. some challenges to get that based on the generation number.
  too many limitations. and patch created didn't pass all the tests.
  so I didn't send that patch.
  But I was talking about this patch (sorry to confuse you).

    Btrfs: device_list_add() should not update list when mounted

  And as of now when its unmounted we expect user to wipe SB
  of the disk which should not belong to the fsid. which will
  solve the problem as well. but a bit of hard work though.
  (there is a chance to notice the _actual_ disks being used
  after the fs is mounted)
----------------

  Above patch will avoid the serious problem that happens
  when disk reappears (on a SElinux)

  when disk reappears on SElinux the device_list_add() is called
  automatically.  And that will replace the disk of a mounted FS.
  This patch will fix that.





> IMO *current* root fix should add the ablity to distinguish different
> deivces even they share
> same uuid.
> And further more, *long term* fix should be not reusing dev uuid and use
> above fix(ablity to distinguish)
> as a fallback.
>
> About the method, I still think Wang's suggestion, using generation to
> distinguish, is good enough for this
> bug.
> It would be quite kind for you to provide any other ideas.

  generation check does not solve the following test case.
     (missing devices are very common incidence at the data centers).
     - replace a missing disk (replace-source) with replace-target
     - unmount
     - now replace-target disappears
     - replace-source which was missing now reappears
     - mount (mounts with replace-source since replace-target is not
       present and so now the generation is greatest on the
       replace-source)
     - unmount
     - now all disks reappears
     - mount would pick replace-source instead of replace-target


  As you mention replace should not clone uuid is the best approach
  for all these issues. I had the same idea when I first notice this
  issue.

  But as of now the above workaround patch is simple and safe.


  Let me know. your thoughts.

Thanks , Anand


