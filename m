Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:39146 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752373AbaBRQ1i (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 18 Feb 2014 11:27:38 -0500
Date: Tue, 18 Feb 2014 17:27:36 +0100
From: David Sterba <dsterba@suse.cz>
To: Chris Murphy <lists@colorremedies.com>
Cc: Tommi Rantala <tt.rantala@gmail.com>, Chris Mason <clm@fb.com>,
        Josef Bacik <jbacik@fb.com>, linux-btrfs@vger.kernel.org,
        Dave Jones <davej@redhat.com>, trinity@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: btrfs "possible irq lock inversion dependency detected"
Message-ID: <20140218162736.GG16073@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20140217200951.GB20312@optiplex>
 <4F3CC8F0-C37E-4448-AF65-796E643A301B@colorremedies.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <4F3CC8F0-C37E-4448-AF65-796E643A301B@colorremedies.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Feb 17, 2014 at 03:14:34PM -0700, Chris Murphy wrote:
> Looks like this is the same thing previously report on Btrfs list with 3.14.0-rc1 here:
> https://bugzilla.redhat.com/show_bug.cgi?id=1062439
> 
> Which points to this:
> https://bugzilla.redhat.com/show_bug.cgi?id=1062833#c24
> 
> Which points to this patch:
> http://marc.info/?l=linux-netdev&m=139233546723342&q=raw

Thanks for the pointer, so it's not a btrfs bug.
