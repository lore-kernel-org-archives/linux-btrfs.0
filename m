Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-bk0-f44.google.com ([209.85.214.44]:51299 "EHLO
	mail-bk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753186Ab3JPPOc (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 16 Oct 2013 11:14:32 -0400
Received: by mail-bk0-f44.google.com with SMTP id mz10so323314bkb.17
        for <linux-btrfs@vger.kernel.org>; Wed, 16 Oct 2013 08:14:31 -0700 (PDT)
MIME-Version: 1.0
Reply-To: fdmanana@gmail.com
In-Reply-To: <525EAC5F.3040201@sandeen.net>
References: <1381932296-14674-1-git-send-email-fdmanana@gmail.com>
	<525EAC5F.3040201@sandeen.net>
Date: Wed, 16 Oct 2013 16:14:30 +0100
Message-ID: <CAL3q7H6N3K7wda5Rm8OYS5a0QYYQr4MbXpxCpahuXVj+dnzozA@mail.gmail.com>
Subject: Re: [PATCH] xfstests: add specific test for default ACL inheritance
From: Filipe David Manana <fdmanana@gmail.com>
To: Eric Sandeen <sandeen@sandeen.net>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        xfs@oss.sgi.com, "dsterba@suse.cz" <dsterba@suse.cz>,
        Josef Bacik <jbacik@fusionio.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Oct 16, 2013 at 4:10 PM, Eric Sandeen <sandeen@sandeen.net> wrote:
> On 10/16/13 9:04 AM, Filipe David Borba Manana wrote:
>> This test is motivated by an issue found by a btrfs user, addressed
>> and described by the following GNU/Linux kernel patch:
>>
>> https://patchwork.kernel.org/patch/3046931/
>
> Hi Filipe, thanks for the patch.
>
> Usually we don't want to add new, possibly-failing cases to old tests;
> that makes it harder to identify when the code regressed vs. when
> the test changed to test new things.
>
> It would be better to just copy the framework of tests/shared/051
> to a new test in shared/ and test only this new inheritance
> problem.

Ok, I wasn't aware of that logic, which makes sense.

>
> Also, I'm confused about this hunk:
>
>> @@ -345,7 +345,12 @@ chacl $acl2 largeaclfile
>>  getfacl --numeric largeaclfile | _filter_aces
>>
>>  echo "1 above xfs acl max"
>> -chacl $acl3 largeaclfile
>> +if [ "$FSTYP" != "btrfs" ]; then
>> +     chacl $acl3 largeaclfile
>> +else
>> +     echo 'chacl: cannot set access acl on "largeaclfile": Invalid argument'
>> +fi
>> +
>>  getfacl --numeric largeaclfile | _filter_aces
>>
>>  echo "use 16 aces"
>
> What's that about?

That chacl command succeeds on btrfs, which makes the test fail. Seems
to rely on some xfs specific limit.
By moving this test into a new file, that hack is no longer needed.

Thanks Eric.

>
> Thanks,
> -Eric
>



-- 
Filipe David Manana,

"Reasonable men adapt themselves to the world.
 Unreasonable men adapt the world to themselves.
 That's why all progress depends on unreasonable men."
