Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:40513 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751777AbbCJNKU (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 10 Mar 2015 09:10:20 -0400
Date: Tue, 10 Mar 2015 14:10:19 +0100
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: tests, clean up scripts
Message-ID: <20150310131019.GA20767@suse.cz>
Reply-To: dsterba@suse.cz
References: <1425900805-11010-1-git-send-email-dsterba@suse.cz>
 <54FE43BA.5080206@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <54FE43BA.5080206@cn.fujitsu.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Mar 10, 2015 at 09:07:06AM +0800, Qu Wenruo wrote:
> > +SUDO_HELPER=
> > +NEED_SUDO_VALIDATE=unknown
> Better quoted?

Not needed here, no sideefects from evaluation and no special chars.

> > @@ -86,15 +86,16 @@ setup_root_helper()
> >   	if [ $UID -eq 0 ]; then
> >   		return
> >   	fi
> > -	# Test for old sudo or special setting, which makes sudo -v fails even
> > -	# user is set NOPASSWD
> > -	sudo -n true &> /dev/null && need_validate=0
> > +
> > +	# Test for old sudo or special settings, which make sudo -v fail even
> > +	# if user setting is NOPASSWD
> > +	sudo -n /bin/true &>/dev/null && NEED_SUDO_VALIDATE=no
> >
> >   	# Newer sudo or default sudo setting
> > -	sudo -v -n &> /dev/null && need_validate=1
> > +	sudo -v -n &>/dev/null && NEED_SUDO_VALIDATE=yes
> >
> > -	if [ $need_validate -eq -1 ]; then
> > -		_not_run "Need validate root privilege"
> > +	if [ "$NEED_SUDO_VALIDATE" = 'yes' ]; then
> Shouldn't it be "$NEED_SUDO_VALIDATE" = 'unknown'?

Right, thanks for catching  it.
