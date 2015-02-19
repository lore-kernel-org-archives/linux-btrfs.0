Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:24203 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750864AbbBSGd6 (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 19 Feb 2015 01:33:58 -0500
Message-ID: <54E583BB.2010707@oracle.com>
Date: Thu, 19 Feb 2015 14:33:31 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: dsterba@suse.cz, Qu Wenruo <quwenruo@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org, clm@fb.com
Subject: Re: [PATCH 1/4] Btrfs-progs: add regression tests for sysfs contents
 during btrfs device management
References: <1423465506-30934-1-git-send-email-anand.jain@oracle.com> <1423465506-30934-2-git-send-email-anand.jain@oracle.com> <54D86EAC.3090803@cn.fujitsu.com> <20150211181911.GI28877@twin.jikos.cz>
In-Reply-To: <20150211181911.GI28877@twin.jikos.cz>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 02/12/2015 02:19 AM, David Sterba wrote:
> On Mon, Feb 09, 2015 at 04:24:12PM +0800, Qu Wenruo wrote:
>> This tests are not even not bind to btrfs-progs.
>> They are kernel tests in fact.
>>
>> So btrfs-progs isn't the best place for it.
>
> Well, I agree. Userspace tools mostly exercise the checker, repair or
> image, ie. mostly offline actions.  The mount test that now exists is to
> really check that the fixed filesystem can be mounted.
>
> The tests Anand proposes perform add, replace, seeding etc. That really
> belongs to fstests.

  we could get sysfs data collection in fstests like this..

  _btrfs_progs()
  {
      btrfs $*
      [[ -z TEST_SYSFS ]] && collect_sysfs_data
  }
  and TEST_SYSFS must be set in the config file.

  Similarly for mount, unmount, modload and modunload etc..

  For now my patches are already tested with  test-btrfs-devmgt, which 
is uploaded here git@github.com:asj/test-btrfs-devmgt.git for reference, 
(but I don't intend to maintain it though).

Thanks,  Anand
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
