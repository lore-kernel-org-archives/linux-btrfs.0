Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:50808 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751262AbdEBQ2C (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 2 May 2017 12:28:02 -0400
Date: Tue, 2 May 2017 18:27:56 +0200
From: David Sterba <dsterba@suse.cz>
To: Christophe de Dinechin <dinechin@redhat.com>
Cc: Btrfs BTRFS <linux-btrfs@vger.kernel.org>
Subject: Re: [PATCH 1/3] Disambiguate between cases where add_tree_backref
 fails
Message-ID: <20170502162755.GR23260@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <A5B22E8A-045F-4214-A64F-622AB47CDCF3@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <A5B22E8A-045F-4214-A64F-622AB47CDCF3@redhat.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Apr 28, 2017 at 11:12:35AM +0200, Christophe de Dinechin wrote:
> See https://bugzilla.redhat.com/show_bug.cgi?id=1435567 for an example
> where the message occurs,
> 
> Signed-off-by: Christophe de Dinechin <dinechin@redhat.com>

Applied, thanks. I've moved the strings to next line so they don't
overflow 80 cols.
