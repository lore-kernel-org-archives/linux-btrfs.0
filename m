Return-Path: <SRS0=2j5R=MU=vger.kernel.org=linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91D92C64EB8
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Oct 2018 05:42:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3B71D2077C
	for <linux-btrfs@archiver.kernel.org>; Mon,  8 Oct 2018 05:42:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.3.2 mail.kernel.org 3B71D2077C
Authentication-Results: mail.kernel.org; dmarc=none (p=none dis=none) header.from=angband.pl
Authentication-Results: mail.kernel.org; spf=none smtp.mailfrom=linux-btrfs-owner@vger.kernel.org
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725941AbeJHMwo (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Mon, 8 Oct 2018 08:52:44 -0400
Received: from tartarus.angband.pl ([54.37.238.230]:59630 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725842AbeJHMwo (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>); Mon, 8 Oct 2018 08:52:44 -0400
Received: from kilobyte by tartarus.angband.pl with local (Exim 4.89)
        (envelope-from <kilobyte@angband.pl>)
        id 1g9OJZ-0001E0-Gt; Mon, 08 Oct 2018 07:42:45 +0200
Date:   Mon, 8 Oct 2018 07:42:45 +0200
From:   Adam Borowski <kilobyte@angband.pl>
To:     Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Cc:     linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: python-btrfs v10 preview... detailed usage reporting and a
 tutorial
Message-ID: <20181008054245.uxys4jbgdenwjnlg@angband.pl>
References: <db9f3d50-a1c7-8a27-c77c-393a1d89b421@mendix.com>
 <20180923231935.go2uksc4g3jpdf6o@angband.pl>
 <132155bb-17c5-0027-60d2-d077f309dcfc@mendix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <132155bb-17c5-0027-60d2-d077f309dcfc@mendix.com>
X-Junkbait: aaron@angband.pl, zzyx@angband.pl
User-Agent: NeoMutt/20170113 (1.7.2)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: kilobyte@angband.pl
X-SA-Exim-Scanned: No (on tartarus.angband.pl); SAEximRunCond expanded to false
Sender: linux-btrfs-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Oct 08, 2018 at 02:03:44AM +0200, Hans van Kranenburg wrote:
> And yes, when promoting things like the new show_usage example to
> programs that are easily available, users will probably start parsing
> the output of them with sed and awk which is a total abomination and the
> absolute opposite of the purpose of the library. So be it. Let it go. :D
> "The code never bothered me any way".

It's not like some deranged person would parse the output of, say, show_file
in Perl...
 
> The interesting question that remains is where the result should go.
> 
> btrfs-heatmap is a thing of its own now, but it's a bit of the "show
> case" example using the lib, with its own collection of documentation
> and even possibility to script it again.
> 
> Shipping the 'binaries' in the python3-btrfs package wouldn't be the
> right thing, so where should they go? apt-get install btrfs-moar-utils-yolo?

At least in Debian, moving executables between packages is a matter of
versioned Replaces (+Conflicts: old), so if any point you decide differently
it's not a problem.  So btrfs-moar-utils-yolo should work well.

> Or should btrfs-progs start to use this to accelerate improvement for
> providing a richer collection of useful progs for things that are not on
> essential level (like, you won't need them inside initramfs, so they can
> use python)?

You might want your own package that's agile and btrfs-progs for things
declared to be rock stable (WRT command-line API, not neccesarily stability
of code).

Meow!
-- 
⢀⣴⠾⠻⢶⣦⠀ 
⣾⠁⢰⠒⠀⣿⡁ 10 people enter a bar: 1 who understands binary,
⢿⡄⠘⠷⠚⠋⠀ 1 who doesn't, D who prefer to write it as hex,
⠈⠳⣄⠀⠀⠀⠀ and 1 who narrowly avoided an off-by-one error.
