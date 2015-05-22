Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-ie0-f179.google.com ([209.85.223.179]:33570 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756229AbbEVTPK (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 22 May 2015 15:15:10 -0400
Received: by iebgx4 with SMTP id gx4so38127308ieb.0
        for <linux-btrfs@vger.kernel.org>; Fri, 22 May 2015 12:15:09 -0700 (PDT)
MIME-Version: 1.0
In-Reply-To: <pan$1c831$68d3ab4d$212d5e11$aaf7c2b4@cox.net>
References: <loom.20150521T231006-840@post.gmane.org>
	<pan$1c831$68d3ab4d$212d5e11$aaf7c2b4@cox.net>
Date: Fri, 22 May 2015 13:15:09 -0600
Message-ID: <CAJCQCtTeoYHganNAJf=cyXzgCN9z1X=G1N=xEbksyRVDpZPbjQ@mail.gmail.com>
Subject: Re: BTRFS RAID5 filesystem corruption during balance
From: Chris Murphy <lists@colorremedies.com>
To: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, May 21, 2015 at 10:43 PM, Duncan <1i5t5.duncan@cox.net> wrote:
> For in-production use, therefore, btrfs raid56 mode, while now at least
> in theory complete, is really too immature at this point to recommend.

At some point perhaps a developer will have time to state the expected
stability level on stable hardware. And what things should be included in a
complete report. I see many reports only including the bug/ Warning with
call trace. And too often problems were happening before that.

The XFS FAQ has an explicit "what to include in a report" other that may
serve as a guide to adapt for Btrfs reports.



-- 
Chris Murphy
