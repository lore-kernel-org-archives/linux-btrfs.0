Return-Path: <SRS0=Z2Dq=N4=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=FREEMAIL_FORGED_FROMDOMAIN,
	FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9A9B9C43441
	for <linux-btrfs@archiver.kernel.org>; Sat, 17 Nov 2018 20:34:25 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 58B6120811
	for <linux-btrfs@archiver.kernel.org>; Sat, 17 Nov 2018 20:34:25 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 58B6120811
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=gmx.de
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726426AbeKRGwP convert rfc822-to-8bit (ORCPT
        <rfc822;linux-btrfs@archiver.kernel.org>);
        Sun, 18 Nov 2018 01:52:15 -0500
Received: from mout.gmx.net ([212.227.15.15]:38097 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725875AbeKRGwO (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Sun, 18 Nov 2018 01:52:14 -0500
Received: from chaos-desktop.localnet ([188.98.54.223]) by mail.gmx.com
 (mrgmx001 [212.227.17.190]) with ESMTPSA (Nemesis) id
 0LhfN3-1fc52l1dTN-00mvue for <linux-btrfs@vger.kernel.org>; Sat, 17 Nov 2018
 21:34:22 +0100
From:   Stephan Olbrich <stephanolbrich@gmx.de>
To:     linux-btrfs@vger.kernel.org
Subject: Re: bad tree block start, want 705757184 have 82362368
Date:   Sat, 17 Nov 2018 21:34:21 +0100
Message-ID: <4413766.Qiva2OXXlC@chaos-desktop>
In-Reply-To: <d41e1327-a08e-8d4c-cbfe-29783a7b83df@suse.com>
References: <1758973.r4I5FPff6i@chaos-desktop> <d41e1327-a08e-8d4c-cbfe-29783a7b83df@suse.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:HsV9eYbIUsmrgfS09wztFadf9NC9a/DkEbjcJTqkAYfsyV3E4ml
 IeTVUGv+ZbV0exkpt6iiJ4RIBccN0LoVYyyuCe39zEC519WbiJLyVdIyqwpKmCFNA0NLwx+
 k4o2O3K59buLSpP6Tk/NOazoHe5O0sJD+c/V8S/YJjf6vrQNE7tMoaZWajK5rt92TBK+I9R
 2bhgJIpg1tmr+j/r2Dp/g==
X-UI-Out-Filterresults: notjunk:1;V01:K0:81f/p0NCwTo=:BG5KxmzkJR42tLMdID6XD7
 kTgQ205f/sOCHhh7KTXthoQwg5raz1w+u0DVB2a+phrPprENiRHeQCq1aAvc5PoPyGMOpQ8ce
 DY0fTP/jix8doK7KJpkic2/u9wg4nxaouJLlFokSNgliwCXYtue+hFq+BQ9oCKHNn8f+LjpFo
 cv/73ozZXwrwvaWuz1rbyYa5+HVFiuWAzHC39u5YMquqqWeDBuA5IgwIAQAa8tqsY4XENqS8r
 L3f3EC2IRb05KndGuYlAhSJsVS1o+EzRw5t/rWRiZr1vn0jervz9GJ8kwUqfrbMtfyiPoKgGc
 ENPmeijGSyHFk2ck5FXBJyG5QP6Nh4+VTHzkvUVZDeRpywPy7XysC1jWEt6zv6miMddLf5M6e
 Z3CyXfC+fBI+9aZd4jumMJtKTlwWp//H2f+fgXHeM7RWwQ4Q3qoE7ThlzrS0LnQUn6THEuVDb
 lVNAF6wGLVx0ZP0p+WhtTwb2VLP5p5git+0eSDR49fxEfTpmUA/iFVVJhnLA8uZqULVkFP2wx
 vShIQJpKoPGXeFpzfdbv6Gkc54N6cMdLEc/HRPEzvYifuwjKhhQNo2XQrwnivJ2D/omoHIR+D
 /5aM0729RA59KN5r0rfFE9OJGnuJq1x1J9PR+VtWBjteWTXEmD/s3WBjR0GrOl0iskuRWSmt7
 fEYyqCnPpO7XEUuFr67b9MlHmdEohoOy/spn1wv1j6jNlGeM5hl3LTCUZukjKM8vkqWGZT8Uv
 V2FhoqY2W8ifne/426oMXAb1QKrul5jHkkPoSzGNUDrt7VFvEPzD8GEG8XDv/jVaU/Qiciu/B
 CsRKfrkhtz0lIbfJZHyeeaFCRnpJL/bLtTl+cWyudXZ6pDjf5tLGmT6seUJgfpLwSvutO9L5S
 y5f6JtEys7OwE23xMFoIvpJxcbLyTQZTRXRPgoh+82opKWIGUB0oZqVHQGVXfSX3U6mYrT/bQ
 YFc2W5gjspw==
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

Am Freitag, 16. November 2018, 17:44:35 CET schrieb Nikolay Borisov:
> On 16.11.18 г. 18:17 ч., Stephan Olbrich wrote:
> > Hi,
> > 
> > a few days ago my root file system (simple btrfs on a SSD, no RAID or
> > anything) suddenly became read only. Looking at dmsg, I found this:
> > 
> > [   19.285020] BTRFS error (device sda2): bad tree block start, want
> > 705757184 have 82362368 [   19.285042] BTRFS: error (device sda2) in
> > __btrfs_free_extent:6804: errno=-5 IO failure [   19.285048] BTRFS info
> > (device sda2): forced readonly
> > [   19.285051] BTRFS: error (device sda2) in btrfs_run_delayed_refs:2934:
> > errno=-5 IO failure [   19.287213] BTRFS error (device sda2): pending
> > csums is 41889792
> > 
> > Late on I got the same errors for my /home partition (on the same drive)
> > as well. I have snapshots of all partitions on another drive made by
> > btrbk. To get a working system, I made new (rw) snapshots of the most
> > recent backup and setup grub and fstab, so my system would boot from the
> > other drive. Unfortunately now I got the "bad tree block start" error
> > again at least once in dmesg but I didn't save it and it's not in syslog
> > :-( What I remember is, that it was followed by other btrfs error
> > messages saying something about correcting something. And the filesystem
> > was still read/write this time.
> > At the moment I can't reproduce it.
> > 
> > Is there any way to find out, which files are affected by the errors
> > above? I don't really trust the data on the drive I'm using at the
> > moment, as it has shown errors as well, but I have a less current backup
> > on yet another drive but at it is a few weeks old, I don't want to use it
> > to setup the system on the SSD again, but just copy the relevant files if
> > possible. Or is it possible to repair the original file system?
> > 
> > Some information about my system:
> > Kubuntu 18.04
> > Kernel 4.19.1 when the problem occured, now 4.19.2
> > btrfs-tools 4.15.1
> 
> What is the SMART status of your SSD, how old is the ssd. This really
> sounds like the drive going to lalal land.

The SSD is 3.5 years old and was never really full, so I wouldn't expect it to 
die. SMART shows no errors. All values are way above the threshold and 
selftests show no errors.
I checked RAM as well. No errors there, so I have no clue, where these errors 
come from.

Regards,
Stephan




