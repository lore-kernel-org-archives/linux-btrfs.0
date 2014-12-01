Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from meiko.romanrm.net ([195.154.97.166]:52647 "EHLO
	meiko.romanrm.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752404AbaLANqY (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 1 Dec 2014 08:46:24 -0500
Date: Mon, 1 Dec 2014 18:46:21 +0500
From: Roman Mamedov <rm@romanrm.net>
To: Shriramana Sharma <samjnaa@gmail.com>
Cc: Austin S Hemmelgarn <ahferroin7@gmail.com>, Marc MERLIN <marc@merlins.org>,
        linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Possible to undo subvol delete?
Message-ID: <20141201184621.5dd7fcd9@natsu>
In-Reply-To: <CAH-HCWW4vUXzM6S1fCzwxdPiWHBZaf5ZNZexjRmND2WkzNK-qg@mail.gmail.com>
References: <CAH-HCWW+C9VSV0vb5D1SfU+5md8=zfrZiAbK4cqFiGFW4bKR4w@mail.gmail.com>
	<20141130042306.GE8916@merlins.org>
	<547C6922.6030206@gmail.com>
	<CAH-HCWW4vUXzM6S1fCzwxdPiWHBZaf5ZNZexjRmND2WkzNK-qg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, 1 Dec 2014 18:49:23 +0530
Shriramana Sharma <samjnaa@gmail.com> wrote:

> As I requested there, I prefer for confirmation by default and -f to
> force otherwise, rather than behaviour of rm which requires -i to ask
> confirmation.

And I prefer the current behavior (also replied on the bug).

A more sensible idea could be adding a global-level '-i' switch, same as in
'rm', so that you or distros could then alias 'btrfs' to 'btrfs -i' (ask
confirmation on any irreversible action).

-- 
With respect,
Roman
