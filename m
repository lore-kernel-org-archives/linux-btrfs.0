Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44484 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754398AbbHYPNc (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Tue, 25 Aug 2015 11:13:32 -0400
Date: Tue, 25 Aug 2015 17:12:56 +0200
From: David Sterba <dsterba@suse.cz>
To: Alexandru Moise <00moses.alexander00@gmail.com>
Cc: clm@fb.com, jbacik@fb.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: Fixed declaration of old_len
Message-ID: <20150825151256.GG10756@suse.cz>
Reply-To: dsterba@suse.cz
References: <20150824215628.GA18871@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20150824215628.GA18871@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Aug 24, 2015 at 09:56:28PM +0000, Alexandru Moise wrote:
> old_len is used to store the return value of btrfs_item_size_nr().
> The return value of btrfs_item_size_nr() is of type u32.
> To improve code correctness and avoid mixing signed and unsigned
> integers I've changed old_len to be of type u32 as well.
> 
> Signed-off-by: Alexandru Moise <00moses.alexander00@gmail.com>

Reviewed-by: David Sterba <dsterba@suse.com>
