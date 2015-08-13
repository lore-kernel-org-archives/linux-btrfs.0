Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:35450 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862AbbHMOjj (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 13 Aug 2015 10:39:39 -0400
Message-ID: <55CCAC1D.8010803@oracle.com>
Date: Thu, 13 Aug 2015 22:39:25 +0800
From: Anand Jain <anand.jain@oracle.com>
MIME-Version: 1.0
To: fdmanana@gmail.com
CC: fstests@vger.kernel.org,
        "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>,
        "dsterba@suse.cz" <dsterba@suse.cz>,
        Dave Chinner <david@fromorbit.com>
Subject: Re: [PATCH v4 1/3] xfstests: btrfs: add functions to create dm-error
 device
References: <1430388527-16700-1-git-send-email-anand.jain@oracle.com>	<1437560043-336-1-git-send-email-anand.jain@oracle.com>	<1437560043-336-2-git-send-email-anand.jain@oracle.com> <CAL3q7H57aHmHnMsZqVOsT6T4vqp5ZDug4=8vSm9025ppGNiPJA@mail.gmail.com>
In-Reply-To: <CAL3q7H57aHmHnMsZqVOsT6T4vqp5ZDug4=8vSm9025ppGNiPJA@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>



>> +# this test requires the device mapper error target
>> +#
>> +_require_dmerror()
>> +{
>> +    _require_command "$DMSETUP_PROG" dmsetup
>> +
>> +    $DMSETUP_PROG targets | grep error >/dev/null 2>&1
>> +    if [ $? -eq 0 ]
>> +    then
>> +       :
>> +    else
>> +       _notrun "This test requires dm error support"
>> +    fi
>
> Why not just:
>
> [ $? -ne 0 ] && _notrun "This test requires dm error support"
>
> The empty branch doesn't make much sense.

  yes.

> Also, please indent the body of this function using an 8 spaces tab,
> which is the official style for fstests (just look at the surrounding
> functions for example).

  not sure how this got slipped. I am fixing it.

> Other than that, it looks good to me. You can add:
>
> Reviewed-by: Filipe Manana <fdmanana@suse.com>

Thanks.
Anand
