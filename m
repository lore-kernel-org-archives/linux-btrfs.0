Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([54.37.238.230]:46290 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725741AbeIXFif (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Sep 2018 01:38:35 -0400
Date: Mon, 24 Sep 2018 01:19:35 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: Hans van Kranenburg <hans.van.kranenburg@mendix.com>
Cc: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: python-btrfs v10 preview... detailed usage reporting and a
 tutorial
Message-ID: <20180923231935.go2uksc4g3jpdf6o@angband.pl>
References: <db9f3d50-a1c7-8a27-c77c-393a1d89b421@mendix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <db9f3d50-a1c7-8a27-c77c-393a1d89b421@mendix.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Sep 23, 2018 at 11:54:12PM +0200, Hans van Kranenburg wrote:
> Two examples have been added, which use the new code. I would appreciate
> extra testing. Please try them and see if the reported numbers make sense:
> 
> space_calculator.py
> -------------------
> Best to be initially described as a CLI version of the well-known
> webbased btrfs space calculator by Hugo. ;] Throw a few disk sizes at
> it, choose data and metadata profile and see how much space you would
> get to store actual data.
> 
> See commit message "Add example to calculate usable and wasted space"
> for example output.
> 
> show_usage.py
> -------------
> The contents of the old show_usage.py example that simply showed a list
> of block groups are replaced with a detailed usage report of an existing
> filesystem.

I wonder, perhaps at least some of the examples could be elevated to
commands meant to be run by end-user?  Ie, installing them to /usr/bin/,
dropping the extension?  They'd probably need less generic names, though.


Meow!
-- 
⢀⣴⠾⠻⢶⣦⠀ 10 people enter a bar:
⣾⠁⢰⠒⠀⣿⡁ • 1 who understands binary,
⢿⡄⠘⠷⠚⠋⠀ • 1 who doesn't,
⠈⠳⣄⠀⠀⠀⠀ • and E who prefer to write it as hex.
