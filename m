Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eastrmfepo103.cox.net ([68.230.241.215]:55704 "EHLO
	eastrmfepo103.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569Ab3ATVtM (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sun, 20 Jan 2013 16:49:12 -0500
Received: from eastrmimpo209 ([68.230.241.224]) by eastrmfepo103.cox.net
          (InterMail vM.8.01.04.00 201-2260-137-20101110) with ESMTP
          id <20130120214911.KNYT23841.eastrmfepo103.cox.net@eastrmimpo209>
          for <linux-btrfs@vger.kernel.org>;
          Sun, 20 Jan 2013 16:49:11 -0500
Message-ID: <50FC6656.3040409@czarc.net>
Date: Sun, 20 Jan 2013 16:49:10 -0500
From: Gene Czarcinski <gene@czarc.net>
MIME-Version: 1.0
To: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 07/13] Btrfs-progs: correcting misnamed parameter options
 for btrfs send
References: <1358715858-4469-1-git-send-email-gene@czarc.net> <1358715858-4469-8-git-send-email-gene@czarc.net>
In-Reply-To: <1358715858-4469-8-git-send-email-gene@czarc.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Bad patch ... working on fix

On 01/20/2013 04:04 PM, Gene Czarcinski wrote:
> From: Jan Schmidt <list.btrfs@jan-o-sch.net>
>
> Unfortunately, the command line options for btrfs send were misnamed. The
> -i option should not be used to give "clone sources", we'll be using -c
> instead.
>
> Compatibily note: -i option was broken anyway, which makes it less critical
> renaming it. For potential users of the old option style, we emit a fatal
> warning if the -i option is used.
>
> Signed-off-by: Jan Schmidt <list.btrfs@jan-o-sch.net>
> Signed-off-by: Gene Czarcinski <gene@czarc.net>
>
<snip>
