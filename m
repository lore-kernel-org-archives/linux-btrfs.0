Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx0a-00082601.pphosted.com ([67.231.145.42]:35665 "EHLO
	mx0a-00082601.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750753AbbFLUTO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Fri, 12 Jun 2015 16:19:14 -0400
Message-ID: <557B3E91.3060206@fb.com>
Date: Fri, 12 Jun 2015 16:18:25 -0400
From: Chris Mason <clm@fb.com>
MIME-Version: 1.0
To: Mark Fasheh <mfasheh@suse.de>, <linux-btrfs@vger.kernel.org>
CC: Josef Bacik <jbacik@fb.com>, Matt Robinson <git@nerdoftheherd.com>
Subject: Re: [RESEND][PATCH] btrfs: Align EOF length to block in extent_same
References: <20150610221355.GN18148@wotan.suse.de>
In-Reply-To: <20150610221355.GN18148@wotan.suse.de>
Content-Type: text/plain; charset="windows-1252"
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 06/10/2015 06:13 PM, Mark Fasheh wrote:
> Hi,
> 
> Can this patch please be considered for upstream inclusion? I reviewed
> it myself and have tested it on a few files with an updated duperemove
> branch:
> 
> https://github.com/markfasheh/duperemove/tree/alignment_fix
> 
> as described below, this allows us to dedupe the tail extents of files
> whose size is not block aligned. I have reports from users who hit
> this bug and as a result don't get any space savings and I believe this
> should help them out quite a bit.

Hi Mark,

This one conflicts with your btrfs: Handle unaligned length in
extent_same, which is in integration now.  If we need both, can you
please rework it?

-chris

