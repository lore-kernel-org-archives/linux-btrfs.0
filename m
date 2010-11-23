From: Brian Sullivan <bexamous@gmail.com>
Subject: Re: ls & flush-btrfs-1 sit at 100% sys
Date: Tue, 23 Nov 2010 12:27:09 -0800
Message-ID: <AANLkTinSCdOcXR=9om+oiMZAQS6fOkPuW-gSUTEzkipN@mail.gmail.com>
References: <AANLkTim-esHsiRYTYxAA2WtpOj=XHvZDc6y2+5b0TB0x@mail.gmail.com>
 <m3r5ejyzz4.fsf@pullcord.laptop.org> <AANLkTinKm-6H60V2EivQuKF079yS0W-nS=r5dgw_ZcGm@mail.gmail.com>
 <AANLkTimRtgFy2LwJqsSszOFYSxk9T+qfJ9=snFFGzysf@mail.gmail.com>
 <AANLkTinfcAZrO+UzioG=DtN7KA=aWBB2-BtfZgggqpEm@mail.gmail.com>
 <1290177036-sup-2385@think> <20101119144625.GB2579@localhost.localdomain>
 <AANLkTi=QOzU6Y3JGsiCfkhQCB28DLnOKn8h-iuaNo2-r@mail.gmail.com>
 <AANLkTi=dBcc4aEYDbKtLjjY9dXzaQEqF1tUo5A5W5pmP@mail.gmail.com> <1290473619-sup-3248@think>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: Josef Bacik <josef@redhat.com>,
	Daniel J Blueman <daniel.blueman@gmail.com>,
	Chris Ball <cjb@laptop.org>,
	linux-btrfs <linux-btrfs@vger.kernel.org>
To: Chris Mason <chris.mason@oracle.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <1290473619-sup-3248@think>
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Nov 22, 2010 at 4:54 PM, Chris Mason <chris.mason@oracle.com> w=
rote:
> Excerpts from Brian Sullivan's message of 2010-11-22 18:29:42 -0500:
>> On Fri, Nov 19, 2010 at 12:09 PM, Brian Sullivan <bexamous@gmail.com=
> wrote:
>> > On Fri, Nov 19, 2010 at 6:46 AM, Josef Bacik <josef@redhat.com> wr=
ote:
>> >> On Fri, Nov 19, 2010 at 09:32:46AM -0500, Chris Mason wrote:
>> >>>
>> >>> I just wanted to confirm, you're seeing this with 2.6.37-rc? =A0=
I thought
>> >>> I had fixed up this delalloc hammering.
>> >>>
>> >
>> > I installed 2.6.37-rc2 from an Ubuntu PPA.
>> >
>> >>
>> >> Also can you run with this patch
>> >>
>> >> http://www.spinics.net/lists/linux-btrfs/msg06890.html
>> >>
>> >
>> > Will try tonight.
>> >
>>
>> Got 2.6.37-rc2 from kernel.org, applied this patch, and still not ab=
le
>> to write to the filesystem.
>
> So with the patch are you still seeing the 100% system time?
>
> -chris
>

Yes, no change with patch.

-Brian
--
To unsubscribe from this list: send the line "unsubscribe linux-btrfs" =
in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
