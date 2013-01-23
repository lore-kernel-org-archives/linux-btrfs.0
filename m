Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eastrmfepo102.cox.net ([68.230.241.214]:52584 "EHLO
	eastrmfepo102.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755306Ab3AWPDO (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Wed, 23 Jan 2013 10:03:14 -0500
Received: from eastrmimpo109 ([68.230.241.222]) by eastrmfepo102.cox.net
          (InterMail vM.8.01.04.00 201-2260-137-20101110) with ESMTP
          id <20130123150312.CTAD7113.eastrmfepo102.cox.net@eastrmimpo109>
          for <linux-btrfs@vger.kernel.org>;
          Wed, 23 Jan 2013 10:03:12 -0500
Message-ID: <50FFFBAF.60104@czarc.net>
Date: Wed, 23 Jan 2013 10:03:11 -0500
From: Gene Czarcinski <gene@czarc.net>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
CC: Mike Fleetwood <mike.fleetwood@googlemail.com>
Subject: Re: [PATCH 2/3] Btrfs-progs Add make archive
References: <1358875326-28636-1-git-send-email-gene@czarc.net> <1358875326-28636-3-git-send-email-gene@czarc.net> <CAMU1PDg3is5atwBnKCnA0e-xQAH2GnYZcb1WF4Xk7VRbLL2vVw@mail.gmail.com>
In-Reply-To: <CAMU1PDg3is5atwBnKCnA0e-xQAH2GnYZcb1WF4Xk7VRbLL2vVw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/22/2013 04:52 PM, Mike Fleetwood wrote:
> On 22 January 2013 17:22, Gene Czarcinski<gene@czarc.net>  wrote:
>> >This adds the archive target to the Makefile which simply executes
>> >do-archive.sh.  It also adds the remove of btrfs-progs.spec.in to
> I think you mean btrfs-progs.spec without the .in as that's the generated file.
>
You are correct.
