Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from tartarus.angband.pl ([89.206.35.136]:40755 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750812AbdFVNWq (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 22 Jun 2017 09:22:46 -0400
Date: Thu, 22 Jun 2017 15:22:39 +0200
From: Adam Borowski <kilobyte@angband.pl>
To: Shyam Prasad N <nspmangalore@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: Stability status of btrfs-convert...
Message-ID: <20170622132239.zcwpzdw24lyovcjp@angband.pl>
References: <CANT5p=p_EXUL=zWPqym8BygcQZpFgJk0kK9+zKdE1zgMkJccGQ@mail.gmail.com>
 <20170622123340.dd6qaaxn75k5z7bc@angband.pl>
 <CANT5p=paf=UhTVu4QaMXUeNZmYni3va69mPH9qpHtMGj98GeNw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
In-Reply-To: <CANT5p=paf=UhTVu4QaMXUeNZmYni3va69mPH9qpHtMGj98GeNw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 22, 2017 at 06:48:53PM +0530, Shyam Prasad N wrote:
> The disks that I need to convert could have anywhere from a few GBs to a
> maximum of 4 TB. I plan to add the btrfs-convert to a script which does a
> software upgrade. (The older version used to store data in extra, we've
> moved to btrfs in the newer version). I do have a backup in case I need it.

If you have many of them, splendid!  You can do one or a few, then see if
they explode.  No sudden fireworks -> can proceed with the rest.

-- 
⢀⣴⠾⠻⢶⣦⠀ 
⣾⠁⢠⠒⠀⣿⡁ A dumb species has no way to open a tuna can.
⢿⡄⠘⠷⠚⠋⠀ A smart species invents a can opener.
⠈⠳⣄⠀⠀⠀⠀ A master species delegates.
