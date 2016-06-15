Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:44447 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752696AbcFOIor (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 15 Jun 2016 04:44:47 -0400
Subject: Re: [PATCH 4/6] fstests: btrfs: add helper function to check if btrfs
 is module
To: Eryu Guan <eguan@redhat.com>
References: <1463495530-425-1-git-send-email-anand.jain@oracle.com>
 <1463495530-425-4-git-send-email-anand.jain@oracle.com>
 <20160612045318.GB5140@eguan.usersys.redhat.com>
Cc: fstests@vger.kernel.org, linux-btrfs@vger.kernel.org
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <f36cbe68-710f-adb4-91c6-c0646078a7c9@oracle.com>
Date: Wed, 15 Jun 2016 16:45:31 +0800
MIME-Version: 1.0
In-Reply-To: <20160612045318.GB5140@eguan.usersys.redhat.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



On 06/12/2016 12:53 PM, Eryu Guan wrote:
> On Tue, May 17, 2016 at 10:32:08PM +0800, Anand Jain wrote:
>> We need btrfs to be a module so that it can unloaded and reloaded,
>> so that we can clean up the btrfs internal in memory device list.
>
> It looks like a bug to me if btrfs needs to reload module to clean up
> the device list.
  Definitely not a bug, but a pending enhancement.

> If a user builds btrfs in kernel then he cannot replace
> btrfs device properly?
  No. That's not true.

> Or it's not totally clear to me why a test needs
> to reload btrfs module.

  Sure.
  Test cases such 5/6 and 6/6 needs devices to be un-scanned.
  But as said, as of now we don't have such a feature and
  in a way _reload_btrfs_ko() will help to achieve the device
  un-scan.

  Further we have seen situations where previous test cases
  affects the next test case results. These are bugs,
  but are unintentional at that test case point of viwe, and
  is disturbingly deviating, so these helpers will help to
  start with a clean btrfs memory, so that test results are
  consistent to what is being tested.

>>
>> This patch adds _require_btrfs_unloadable() and _reload_btrfs_ko()
>> to help with the same.
>>
>> Signed-off-by: Anand Jain <anand.jain@oracle.com>
>> ---
>>  common/rc | 12 ++++++++++++
>>  1 file changed, 12 insertions(+)
>>
>> diff --git a/common/rc b/common/rc
>> index f2b39ddbee0c..a9391b4cbf57 100644
>> --- a/common/rc
>> +++ b/common/rc
>> @@ -1403,6 +1403,18 @@ _supported_os()
>>      _notrun "not suitable for this OS: $HOSTOS"
>>  }
>>
>> +_require_btrfs_unloadable()
>
> The name seems misleading, the name indicates that it requires btrfs to
> be unloadable, but in the code it _notrun if btrfs is unloadable.

  ok. Will rename it.

Thanks, Anand


> Thanks,
> Eryu
>
>> +{
>> +	modprobe -r btrfs || _notrun "btrfs unloadable"
>> +	modprobe btrfs || _notrun "Can't load btrfs"
>> +}
>> +
>> +_reload_btrfs_ko()
>> +{
>> +	modprobe -r btrfs || _fail "btrfs unload failed"
>> +	modprobe btrfs || _fail "btrfs load failed"
>> +}
>> +
>>  # this test needs a scratch partition - check we're ok & unmount it
>>  # No post-test check of the device is required. e.g. the test intentionally
>>  # finishes the test with the filesystem in a corrupt state
>> --
>> 2.7.0
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe fstests" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
