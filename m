Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from acsinet15.oracle.com ([141.146.126.227]:16518 "EHLO
	acsinet15.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932678Ab2IRDhQ (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 17 Sep 2012 23:37:16 -0400
Message-ID: <5057ECFB.5000900@oracle.com>
Date: Tue, 18 Sep 2012 11:39:39 +0800
From: Anand Jain <Anand.Jain@oracle.com>
MIME-Version: 1.0
To: Hugo Mills <hugo@carfax.org.uk>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] Btrfs + Btrfs-progs:  make pipe functions re-usable
References: <5052C5A0.4090803@oracle.com> <20120914110432.GE17430@twin.jikos.cz> <5056AB8A.6000500@oracle.com> <20120917102808.GE1129@carfax.org.uk>
In-Reply-To: <20120917102808.GE1129@carfax.org.uk>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


>     As I said in our private email exchange some months ago, I don't
> think this is the right way to be doing this. For example, if you use
> an alternative tool (such as btrfs-gui) which uses the ioctls
> directly, you've lost that logging information.

  I agree with that Hugo. Thanks. These changes are partly for
  the same reason.

>     Keeping a log of what's been done to the FS is much better done by
> extending the available logging in the kernel

  Could you please point out the modules you are talking about.
  I reviewed some but just in case if I have missed out any.



Thanks,  Anand
