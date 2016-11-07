Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44661 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751296AbcKGOCE (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 7 Nov 2016 09:02:04 -0500
Date: Mon, 7 Nov 2016 15:02:00 +0100
From: David Sterba <dsterba@suse.cz>
To: James Pharaoh <james@wellbehavedsoftware.com>
Cc: linux-btrfs@vger.kernel.org, mark@fasheh.com
Subject: Re: Announcing btrfs-dedupe
Message-ID: <20161107140200.GM12522@suse.cz>
Reply-To: dsterba@suse.cz
References: <2855552b-714c-d1de-08f9-89153c293772@wellbehavedsoftware.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <2855552b-714c-d1de-08f9-89153c293772@wellbehavedsoftware.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Nov 06, 2016 at 02:30:52PM +0100, James Pharaoh wrote:
> I'm pleased to announce my btrfs deduplication utility, written in Rust. 
> This operates on whole files, is fast, and I believe complements the 
> existing utilities (duperemove, bedup), which exist currently.

Mark can correct me if I'm wrong, but AFAIK, duperemove can consume
output of fdupes, which does the whole file scanning for duplicates. And
I think adding a whole-file dedup mode to duperemove would be better
(from user's POV) than writing a whole new tool, eg. because of existing
availability of duperemove in the distros.

Also looking to your roadmap, some of the items are implemented in
duperemove: database of existing csums, cross filesystem boundary,
mtime-based speedups).
