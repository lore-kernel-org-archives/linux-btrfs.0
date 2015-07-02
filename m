Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-vn0-f47.google.com ([209.85.216.47]:36156 "EHLO
	mail-vn0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754017AbbGBShH (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 2 Jul 2015 14:37:07 -0400
Received: by vnbg129 with SMTP id g129so12685401vnb.3
        for <linux-btrfs@vger.kernel.org>; Thu, 02 Jul 2015 11:37:06 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <CAC=t97BtoARcnda7aS0QBAerVgYb5z1boXAaJv6CEr9KTkj1ug@mail.gmail.com>
References: <CAC=t97D=Dmq3cu-z2PNjREQn5690+R9NBQsjr5KZ4grYnYr4WA@mail.gmail.com>
	<CAJCQCtSjxs2ZZUgUfrp9q5y+x0fFA7fSnQPgeEXTjsLKZ6DPKw@mail.gmail.com>
	<CAC=t97BiPjTf7yjWoSaoTgjvPZFgyEHdEJzFCG1Mu+nnJGoNoA@mail.gmail.com>
	<CAC=t97Bg3STrTn86HBNYJJm-FT7aiR6tc51tjVnPiArpPgd9XQ@mail.gmail.com>
	<CAC=t97CS5As+3SqZy-sHM4U2JZ0bi_AEq=34bNXu0yBmh8QRjg@mail.gmail.com>
	<CAC=t97AQaDTRinVg9crdAG8zaoj_--L_PLDY3M4_HKHZotnVVg@mail.gmail.com>
	<CAJCQCtRpRg=XdMtAerHfxCWXO74s34=b9LLuk9mvfRhKz8hjFQ@mail.gmail.com>
	<CAC=t97AERgJ06P_Q8vbz=-yC=H3ODUkTt7ZD1Zpimr_jft+S6g@mail.gmail.com>
	<CAJCQCtSB+29V-UdL5JZAHu3Zv3-XH0SyL8E5MwHgyeoVQ46Wvg@mail.gmail.com>
	<CAC=t97BOYQJAanPc_EFzxwwakFrY4ALd0sX-n9w_e9JHodU27Q@mail.gmail.com>
	<CAJCQCtTE2QKQij5ziq_wWM=M0bhVKcxAbWVGOPD=R_1ZkvqWPA@mail.gmail.com>
	<CAC=t97A4JtSzXpn9Yr3vhe6Z5JCfKEFB1GfwSLsfYPOWhZ+Zrw@mail.gmail.com>
	<CAJCQCtTPGDmbACtNpXgF-bFbbkLwuNMJyDzP72BsgOL=aREmWQ@mail.gmail.com>
	<CAC=t97BtoARcnda7aS0QBAerVgYb5z1boXAaJv6CEr9KTkj1ug@mail.gmail.com>
Date: Thu, 2 Jul 2015 12:37:06 -0600
Message-ID: <CAJCQCtRFdeOJFn_Ree1dRL04L5SHDOBL87QXZ0beidUhwJCLLQ@mail.gmail.com>
Subject: Re: Any hope of pool recovery?
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jul 2, 2015 at 12:32 PM, Donald Pearson
<donaldwhpearson@gmail.com> wrote:
> I think it is.  I have another raid5 pool that I've created to test
> the restore function on, and it worked.

So you have all devices for this raid6 available, and yet when you use
restore, you get missing device message for all devices except the one
specified? But that doesn't happen with the raid5 volume?


-- 
Chris Murphy
