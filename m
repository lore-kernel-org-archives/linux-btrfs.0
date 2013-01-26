Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from eastrmfepo103.cox.net ([68.230.241.215]:35014 "EHLO
	eastrmfepo103.cox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752343Ab3AZSTP (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 26 Jan 2013 13:19:15 -0500
Received: from eastrmimpo306 ([68.230.241.238]) by eastrmfepo103.cox.net
          (InterMail vM.8.01.04.00 201-2260-137-20101110) with ESMTP
          id <20130126181914.KKCP23841.eastrmfepo103.cox.net@eastrmimpo306>
          for <linux-btrfs@vger.kernel.org>;
          Sat, 26 Jan 2013 13:19:14 -0500
Message-ID: <51041E21.8040405@czarc.net>
Date: Sat, 26 Jan 2013 13:19:13 -0500
From: Gene Czarcinski <gene@czarc.net>
MIME-Version: 1.0
To: David Sterba <dsterba@suse.cz>, linux-btrfs@vger.kernel.org
Subject: Re: Integration branch of btrfs-progs 2013-01-26 [not to be pulled]
References: <20130126005525.GZ28263@twin.jikos.cz> <20130126111421.GA16594@twin.jikos.cz>
In-Reply-To: <20130126111421.GA16594@twin.jikos.cz>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 01/26/2013 06:14 AM, David Sterba wrote:
> On Sat, Jan 26, 2013 at 01:55:25AM +0100, David Sterba wrote:
>> Eric Sandeen (2):
>>        btrfs-progs pretty/quiet build
> This patch ended up mismerged, I'll fix it here but the branch will
> diverge and is not suitable for pull now.
>
>
David, you appear to have done a fine job of integration and your 
selection of patches appears spot-on to me.

There are to trivial patches I just submitted to fix some formatting and 
a couple of compiler errors:
http://article.gmane.org/gmane.comp.file-systems.btrfs/22669
http://article.gmane.org/gmane.comp.file-systems.btrfs/22668

BTW, what was wrong with the quiet-build patch?

I am almost completely rebased and plan to begin testing later today.

Gene

Gene
