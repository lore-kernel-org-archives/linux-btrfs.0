Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from jeru.org ([195.216.214.75]:37076 "EHLO jeru.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752158Ab2EZKHR (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Sat, 26 May 2012 06:07:17 -0400
Date: Sat, 26 May 2012 11:52:44 +0200
From: Xavier Nicollet <nicollet@jeru.org>
To: linux-btrfs@vger.kernel.org
Subject: Re: atime and filesystems with snapshots (especially Btrfs)
Message-ID: <20120526095244.GD12396@jeru.org>
Reply-To: nicollet@jeru.org
References: <CAB9VWqAUkHH2xBXZ+edTSCffiLtEXamfugKrPZ6T0Py92kyZdA@mail.gmail.com>
 <20120525154249.GC2082@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
In-Reply-To: <20120525154249.GC2082@localhost.localdomain>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Le 25 May 2012 ? 11:42, Josef Bacik a écrit:
> Just mount with -o noatime, there's no chance of turning something like that on
> by default since it will break some applications (notably mutt).  Thanks,

I've just updated the wiki:
https://btrfs.wiki.kernel.org/index.php/Mount_options#Performance

-- 
Xavier Nicollet
