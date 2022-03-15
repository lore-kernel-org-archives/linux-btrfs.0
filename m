Return-Path: <linux-btrfs-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 519D5C433F5
	for <linux-btrfs@archiver.kernel.org>; Tue, 15 Mar 2022 20:02:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351397AbiCOUEH (ORCPT <rfc822;linux-btrfs@archiver.kernel.org>);
        Tue, 15 Mar 2022 16:04:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237038AbiCOUEG (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 15 Mar 2022 16:04:06 -0400
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C90F91BEB0
        for <linux-btrfs@vger.kernel.org>; Tue, 15 Mar 2022 13:02:53 -0700 (PDT)
Received: from relay2.suse.de (relay2.suse.de [149.44.160.134])
        by smtp-out2.suse.de (Postfix) with ESMTP id 87C171F391;
        Tue, 15 Mar 2022 20:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.cz; s=susede2_rsa;
        t=1647374572;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JidClg+f/a0VJYRrn0cRAZCM+DTjK72neT3tNpZHpJg=;
        b=gH2PJI0iEDCaFgtrtZbjwqVFhtbN12f4sxsBCyPkNbhAr5D1OUiZPl1k4RKiBDCw5RVcJI
        YZ4CIT8GU1vr47r8LZ/Lh7+xWUPYb5Ku9gWjOQ3fso38KDAHWIu8gFIGf9jfmW7VGKuBiR
        9xAAmjj9KXK7FUvU6OfMnqrjYDoW7fc=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.cz;
        s=susede2_ed25519; t=1647374572;
        h=from:from:reply-to:reply-to:date:date:message-id:message-id:to:to:
         cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=JidClg+f/a0VJYRrn0cRAZCM+DTjK72neT3tNpZHpJg=;
        b=FbSMv0nhdgUC+gOCJ3ZgW/fYwpOrH0WInzw2EVPGvsjMxIXTQ0ecVqobHQyFqKfjFZRHV6
        EBtVZQgGtfcMGfBw==
Received: from ds.suse.cz (ds.suse.cz [10.100.12.205])
        by relay2.suse.de (Postfix) with ESMTP id 7BC9CA3B89;
        Tue, 15 Mar 2022 20:02:52 +0000 (UTC)
Received: by ds.suse.cz (Postfix, from userid 10065)
        id 326E2DA7E1; Tue, 15 Mar 2022 20:58:52 +0100 (CET)
Date:   Tue, 15 Mar 2022 20:58:52 +0100
From:   David Sterba <dsterba@suse.cz>
To:     "Darrick J. Wong" <djwong@kernel.org>
Cc:     Filipe Manana <fdmanana@kernel.org>, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH v2] btrfs: fix fallocate to use file_modified to update
 permissions consistently
Message-ID: <20220315195852.GV12643@twin.jikos.cz>
Reply-To: dsterba@suse.cz
Mail-Followup-To: dsterba@suse.cz, "Darrick J. Wong" <djwong@kernel.org>,
        Filipe Manana <fdmanana@kernel.org>, linux-btrfs@vger.kernel.org
References: <20220314175532.GB8165@magnolia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220314175532.GB8165@magnolia>
User-Agent: Mutt/1.5.23.1-rc1 (2014-03-12)
Precedence: bulk
List-ID: <linux-btrfs.vger.kernel.org>
X-Mailing-List: linux-btrfs@vger.kernel.org

On Mon, Mar 14, 2022 at 10:55:32AM -0700, Darrick J. Wong wrote:
> From: Darrick J. Wong <djwong@kernel.org>
> 
> Since the initial introduction of (posix) fallocate back at the turn of
> the century, it has been possible to use this syscall to change the
> user-visible contents of files.  This can happen by extending the file
> size during a preallocation, or through any of the newer modes (punch,
> zero range).  Because the call can be used to change file contents, we
> should treat it like we do any other modification to a file -- update
> the mtime, and drop set[ug]id privileges/capabilities.
> 
> The VFS function file_modified() does all this for us if pass it a
> locked inode, so let's make fallocate drop permissions correctly.
> 
> Signed-off-by: Darrick J. Wong <djwong@kernel.org>
> ---
> v2: move up file_modified to catch a case where we could modify file
> contents but fail on something else before we end up calling
> file_modified

Added to misc-next, thanks.
