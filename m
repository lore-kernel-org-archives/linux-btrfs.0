From: Brian Sullivan <bexamous@gmail.com>
Subject: Re: ls & flush-btrfs-1 sit at 100% sys
Date: Mon, 22 Nov 2010 15:29:42 -0800
Message-ID: <AANLkTi=dBcc4aEYDbKtLjjY9dXzaQEqF1tUo5A5W5pmP@mail.gmail.com>
References: <AANLkTim-esHsiRYTYxAA2WtpOj=XHvZDc6y2+5b0TB0x@mail.gmail.com>
 <m3r5ejyzz4.fsf@pullcord.laptop.org> <AANLkTinKm-6H60V2EivQuKF079yS0W-nS=r5dgw_ZcGm@mail.gmail.com>
 <AANLkTimRtgFy2LwJqsSszOFYSxk9T+qfJ9=snFFGzysf@mail.gmail.com>
 <AANLkTinfcAZrO+UzioG=DtN7KA=aWBB2-BtfZgggqpEm@mail.gmail.com>
 <1290177036-sup-2385@think> <20101119144625.GB2579@localhost.localdomain> <AANLkTi=QOzU6Y3JGsiCfkhQCB28DLnOKn8h-iuaNo2-r@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Chris Mason <chris.mason@oracle.com>,
	Daniel J Blueman <daniel.blueman@gmail.com>,
	Chris Ball <cjb@laptop.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <AANLkTi=QOzU6Y3JGsiCfkhQCB28DLnOKn8h-iuaNo2-r@mail.gmail.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Nov 19, 2010 at 12:09 PM, Brian Sullivan <bexamous@gmail.com> w=
rote:
> On Fri, Nov 19, 2010 at 6:46 AM, Josef Bacik <josef@redhat.com> wrote=
:
>> On Fri, Nov 19, 2010 at 09:32:46AM -0500, Chris Mason wrote:
>>>
>>> I just wanted to confirm, you're seeing this with 2.6.37-rc? =A0I t=
hought
>>> I had fixed up this delalloc hammering.
>>>
>
> I installed 2.6.37-rc2 from an Ubuntu PPA.
>
>>
>> Also can you run with this patch
>>
>> http://www.spinics.net/lists/linux-btrfs/msg06890.html
>>
>
> Will try tonight.
>

Got 2.6.37-rc2 from kernel.org, applied this patch, and still not able
to write to the filesystem.

I hooked up another array (md raid w/btfs on top) and it this one
works fine.  Should I just wipe out of the broken fs and recreate it?
Or is there anything else I should try?

-Brian

> -Brian
>
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
