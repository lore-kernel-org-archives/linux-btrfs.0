Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:49256 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753270AbbAENd6 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Mon, 5 Jan 2015 08:33:58 -0500
Date: Mon, 5 Jan 2015 14:33:56 +0100
From: David Sterba <dsterba@suse.cz>
To: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: reada: Remove unused function
Message-ID: <20150105133356.GF6114@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1420333197-6245-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1420333197-6245-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Sun, Jan 04, 2015 at 01:59:57AM +0100, Rickard Strandqvist wrote:
> Remove the function btrfs_reada_detach() that is not used anywhere.
> 
> This was partially found by using a static code analysis program called cppcheck.
> 
> Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

No please, this function is part of public readahead API and similar
patch has been NACKed several times.
