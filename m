Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mo-p00-ob.rzone.de ([81.169.146.160]:38107 "EHLO
	mo-p00-ob.rzone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753779Ab3HAItE (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Thu, 1 Aug 2013 04:49:04 -0400
Message-ID: <51FA20FE.7020708@giantdisaster.de>
Date: Thu, 01 Aug 2013 10:49:02 +0200
From: Stefan Behrens <sbehrens@giantdisaster.de>
MIME-Version: 1.0
To: Mathijs Kwik <mathijs@bluescreen303.nl>
CC: linux-btrfs <linux-btrfs@vger.kernel.org>
Subject: Re: Problems with incremental btrfs send (out of order instructions?)
References: <CAKvOHKD+cYp+CO4XLXkktnFZ_5n1tZnbrqS3D+T8nJhVEReWig@mail.gmail.com>
In-Reply-To: <CAKvOHKD+cYp+CO4XLXkktnFZ_5n1tZnbrqS3D+T8nJhVEReWig@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, 31 Jul 2013 23:33:59 +0200, Mathijs Kwik wrote:
> Hi all,
> 
> For some time, I've successfully deployed btrfs send/receive as a
> viable backup solution.
> It's fast and flexible and nicely scriptable =)
> However, every once in a while, trouble strikes on the receiving end
> with a message like:
> 
> ERROR: rename nixpkgs/pkgs/applications/version-management/subversion-1.2.x/default.nix
> -> o2979-81788-0 failed. No such file or directory

I've also seen such an errors. It's an error in the send code.

[...]
> Can someone have a look at my dumpfile and confirm this is indeed a
> problem with btrfs send as opposed to something I am doing wrong?

According to your dumpfile, the file nixpkgs/pkgs/applications/version-management/subversion-1.2.x/default.nix needs to be there in the parent subvolume. Apparently it isn't. Since btrfs send enforces that sent snapshots are read-only, and btrfs receive sets received subvolumes to read-only immediately after the reception, it can't be your fault. It has to be the fault of the btrfs send logic.

If you enter a bug on bugzilla.kernel.org (refer to
<https://btrfs.wiki.kernel.org/index.php/Problem_FAQ#How_do_I_report_bugs_and_issues.3F>),
you increase the probability that somebody fixes the issue some day :)

