Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from blu004-omc1s14.hotmail.com ([65.55.116.25]:53144 "EHLO
	BLU004-OMC1S14.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752893AbbAON4G convert rfc822-to-8bit
	(ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 15 Jan 2015 08:56:06 -0500
Message-ID: <BLU436-SMTP343CFC114982188D28D3ECB74E0@phx.gbl>
Date: Thu, 15 Jan 2015 21:50:43 +0800
From: =?utf-8?B?5qiK5oiQ6YW/?= <fcn11@outlook.com>
MIME-Version: 1.0
To: dsterba@suse.cz,
        =?UTF-8?B?RmFuIENoZW5nbmlhbmcv5qiK5oiQ6YW/?=
	<fancn.fnst@cn.fujitsu.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2 RESEND] btrfs-progs: make btrfs qgroups show human
 readable sizes
References: <1421128419-17169-1-git-send-email-fancn.fnst@cn.fujitsu.com> <20150114154633.GU3685@twin.jikos.cz> <54B7150D.20903@cn.fujitsu.com> <20150115123003.GE3685@twin.jikos.cz>
In-Reply-To: <20150115123003.GE3685@twin.jikos.cz>
Content-Type: text/plain; charset="utf-8"; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


在 2015年01月15日 20:30, David Sterba 写道:
> On Thu, Jan 15, 2015 at 09:17:01AM +0800, Fan Chengniang/樊成酿 wrote:
>> 在 2015年01月14日 23:46, David Sterba 写道:
>>> On Tue, Jan 13, 2015 at 01:53:39PM +0800, Fan Chengniang wrote:
>>>> make btrfs qgroups show human readable sizes
>>>> using --human-readable option, example:
>>> That's too long to type and the idea was to add all the long options
>>> that force the specific unit base, ie. --kbytes/--mbytes/..., --raw,
>>> --si and --iec. We can possibly make the human readable the default
>>> because that's what I'd expect to see to have a quick overview and can
>>> use the other options otherwise.
>>>
>>> The geopt parser accepts short options if they're unique, so --kb or
>>> even --k works as a very convenient shorcut for frequent commandline
>>> use.
>> I have sent a mail for your advise of adding options. In that mail, I
>> asked whether I should use --human-readable and add --kbytes --mbytes ...
>> But you have not reply to me.
> So you've sent a v2 where we can see if our ideas match or not and
> continue from there. Timely replies are not always feasible, I get a lot
> of mails. Patch iterations are normal, nothing new here.
Sorry to you because of my words. I didn't consider you have a lot of 
mails. I will take your advice and improve my patch.
This is my personal mail address.
>> So, your advise is add --kbytes --mbytes ... and make human-readable
>> default behaviour?
>>>> qgroupid rfer         excl         max_rfer     max_excl     parent  child
>>>> -------- ----         ----         --------     --------     ------  -----
>>>> 0/5      299.58MiB    299.58MiB    400.00MiB    0.00B        1/1     ---
>>>> 0/265    299.58MiB    16.00KiB     0.00B        320.00MiB    1/1     ---
>>>> 0/266    299.58MiB    16.00KiB     350.00MiB    0.00B        ---     ---
>>>> 1/1      599.16MiB    299.59MiB    800.00MiB    0.00B        ---     0/5,0/265
>>> The values should be also aligned to the right.
>> It is aligned to left before my patch. I just keep it.
> Ok, take it as a hint for another patch.
I have combined them to one patch. Maybe I should seperate them.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

