Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:52257 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751457AbdF0PmH (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 27 Jun 2017 11:42:07 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id F32D6AD25
        for <linux-btrfs@vger.kernel.org>; Tue, 27 Jun 2017 15:42:05 +0000 (UTC)
Date: Tue, 27 Jun 2017 17:40:56 +0200
From: David Sterba <dsterba@suse.cz>
To: Edmund Nadolski <enadolski@suse.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 06/13] btrfs: btrfs_check_shared should manage its own
 transaction
Message-ID: <20170627154056.GX2866@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20170620160653.19907-1-enadolski@suse.com>
 <20170620160653.19907-7-enadolski@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170620160653.19907-7-enadolski@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Jun 20, 2017 at 10:06:46AM -0600, Edmund Nadolski wrote:

At least some description should be put here, why the transaction is
being moved to btrfs_check_shared.
