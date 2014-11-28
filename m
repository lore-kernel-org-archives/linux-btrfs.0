Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-wg0-f52.google.com ([74.125.82.52]:61034 "EHLO
	mail-wg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751142AbaK1PzL (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 28 Nov 2014 10:55:11 -0500
Received: by mail-wg0-f52.google.com with SMTP id a1so9166885wgh.25
        for <linux-btrfs@vger.kernel.org>; Fri, 28 Nov 2014 07:55:10 -0800 (PST)
MIME-Version: 1.0
In-Reply-To: <5474FF63.5030008@ubuntu.com>
References: <E1XqYMg-0000YI-8y@watricky.valid.co.za>
	<546AF572.2020101@swiftspirit.co.za>
	<20141118153526.GS20972@merlins.org>
	<47FB8035-FEA6-40E1-9672-5BBF92B283A9@colorremedies.com>
	<546BB2EA.5080809@ubuntu.com>
	<pan$7c051$a7c25939$cafa59e$f63379c9@cox.net>
	<546CC04F.6040207@ubuntu.com>
	<pan$440ce$23845ab3$4bdb3665$b30296cb@cox.net>
	<5474FF63.5030008@ubuntu.com>
Date: Fri, 28 Nov 2014 16:55:10 +0100
Message-ID: <CAA7pwKOpsaOc6NpsiZWbvo_QYTEChPPRt03ff56ioZOFBaajXA@mail.gmail.com>
Subject: Re: scrub implies failing drive - smartctl blissfully unaware
From: Patrik Lundquist <patrik.lundquist@gmail.com>
To: Phillip Susi <psusi@ubuntu.com>
Cc: "linux-btrfs@vger.kernel.org" <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 25 November 2014 at 23:14, Phillip Susi <psusi@ubuntu.com> wrote:
> On 11/19/2014 6:59 PM, Duncan wrote:
>
>> The paper specifically mentioned that it wasn't necessarily the
>> more expensive devices that were the best, either, but the ones
>> that faired best did tend to have longer device-ready times.  The
>> conclusion was that a lot of devices are cutting corners on
>> device-ready, gambling that in normal use they'll work fine,
>> leading to an acceptable return rate, and evidently, the gamble
>> pays off most of the time.
>
> I believe I read the same study and don't recall any such conclusion.
>  Instead the conclusion was that the badly behaving drives aren't
> ordering their internal writes correctly and flushing their metadata
> from ram to flash before completing the write request.  The problem
> was on the power *loss* side, not the power application.

I've found:

http://www.usenix.org/conference/fast13/technical-sessions/presentation/zheng
http://lkcl.net/reports/ssd_analysis.html

Are there any more studies?
