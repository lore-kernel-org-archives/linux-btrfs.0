Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from sandeen.net ([63.231.237.45]:51266 "EHLO sandeen.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756852Ab3JPPTE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Oct 2013 11:19:04 -0400
Message-ID: <525EAE67.5020509@sandeen.net>
Date: Wed, 16 Oct 2013 10:19:03 -0500
From: Eric Sandeen <sandeen@sandeen.net>
MIME-Version: 1.0
To: fdmanana@gmail.com
CC: Josef Bacik <jbacik@fusionio.com>, "dsterba@suse.cz" <dsterba@suse.cz>,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        xfs@oss.sgi.com
Subject: Re: [PATCH] xfstests: add specific test for default ACL inheritance
References: <1381932296-14674-1-git-send-email-fdmanana@gmail.com> <525EAC5F.3040201@sandeen.net> <CAL3q7H6N3K7wda5Rm8OYS5a0QYYQr4MbXpxCpahuXVj+dnzozA@mail.gmail.com>
In-Reply-To: <CAL3q7H6N3K7wda5Rm8OYS5a0QYYQr4MbXpxCpahuXVj+dnzozA@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 10/16/13 10:14 AM, Filipe David Manana wrote:
> On Wed, Oct 16, 2013 at 4:10 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
>> On 10/16/13 9:04 AM, Filipe David Borba Manana wrote:
>>> This test is motivated by an issue found by a btrfs user, addressed
>>> and described by the following GNU/Linux kernel patch:
>>>
>>> https://patchwork.kernel.org/patch/3046931/
>>
>> Hi Filipe, thanks for the patch.
>>
>> Usually we don't want to add new, possibly-failing cases to old tests;
>> that makes it harder to identify when the code regressed vs. when
>> the test changed to test new things.
>>
>> It would be better to just copy the framework of tests/shared/051
>> to a new test in shared/ and test only this new inheritance
>> problem.
> 
> Ok, I wasn't aware of that logic, which makes sense.
> 
>>
>> Also, I'm confused about this hunk:
>>
>>> @@ -345,7 +345,12 @@ chacl $acl2 largeaclfile
>>>  getfacl --numeric largeaclfile | _filter_aces
>>>
>>>  echo "1 above xfs acl max"
>>> -chacl $acl3 largeaclfile
>>> +if [ "$FSTYP" != "btrfs" ]; then
>>> +     chacl $acl3 largeaclfile
>>> +else
>>> +     echo 'chacl: cannot set access acl on "largeaclfile": Invalid argument'
>>> +fi
>>> +
>>>  getfacl --numeric largeaclfile | _filter_aces
>>>
>>>  echo "use 16 aces"
>>
>> What's that about?
> 
> That chacl command succeeds on btrfs, which makes the test fail. Seems
> to rely on some xfs specific limit.
> By moving this test into a new file, that hack is no longer needed.

Oh, if I'd read the context... ;)

>>>  echo "1 above xfs acl max"

and:

XFS_ACL_MAX_ENTRIES=25
num_aces_pre=`expr $XFS_ACL_MAX_ENTRIES - 1`
num_aces_post=`expr $XFS_ACL_MAX_ENTRIES + 1`

acl1=`_create_n_aces $num_aces_pre`
acl2=`_create_n_aces $XFS_ACL_MAX_ENTRIES`
acl3=`_create_n_aces $num_aces_post`

Sorry for not reading more.

interesting that it's a udf test too...

Ok, but right - it's testing an xfs specific limit.

Your new test can probably be generic, with a _require_acls
to skip the test on any fs w/o acl support.

Thanks,

-Eric
> Thanks Eric.
> 
>>
>> Thanks,
>> -Eric
>>
> 
> 
> 

