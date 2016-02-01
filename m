Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cc-smtpout3.netcologne.de ([89.1.8.213]:59877 "EHLO
	cc-smtpout3.netcologne.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932325AbcBAODN (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Feb 2016 09:03:13 -0500
Subject: Re: Progress indicator when (slowly) mounting a btrfs filesystem?
To: Chris Murphy <lists@colorremedies.com>
References: <56A8EF4F.7060900@netcologne.de>
 <CAJCQCtQ6RwedgskkT9EECdj_2aZVEZZhfNwvkqOWztzk-MyKTg@mail.gmail.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
From: Christian Rohmann <crohmann@netcologne.de>
Message-ID: <56AF659E.2080009@netcologne.de>
Date: Mon, 1 Feb 2016 15:03:10 +0100
MIME-Version: 1.0
In-Reply-To: <CAJCQCtQ6RwedgskkT9EECdj_2aZVEZZhfNwvkqOWztzk-MyKTg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hey Chris,

On 01/28/2016 12:47 AM, Chris Murphy wrote:
> Might be a bug, but more likely might be a lack of optimization. If it
> eventually mounts without errors that's a pretty good plus. Lots of
> file systems can't handle power failures well at all.

So what and how should I go about profiling such a long running mount in
order to help finding point where optimization is needed the most then?

Just as a side note: I don't think it's your own expectation to be like
all those other file systems ;-)


Regards

Christian
