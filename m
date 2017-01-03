Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:36593 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1759373AbdACQC2 (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Tue, 3 Jan 2017 11:02:28 -0500
Date: Tue, 3 Jan 2017 17:02:12 +0100
From: David Sterba <dsterba@suse.cz>
To: Philippe Loctaux <phil@philippeloctaux.com>
Cc: clm@fb.com, jbacik@fb.com, dsterba@suse.com, linux-btrfs@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] btrfs: file.c: file cleanup
Message-ID: <20170103160211.GO12081@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <1481897853-13232-1-git-send-email-phil@philippeloctaux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1481897853-13232-1-git-send-email-phil@philippeloctaux.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Dec 16, 2016 at 03:17:33PM +0100, Philippe Loctaux wrote:
> cleaned up the file with checkpatch
                      ^^^^^^^^^^^^^^^

Sorry, this is an example of what should not be done. Checkpatch can
detect lots of things that once were valid or tolerated but are not
today. There are minor coding style violations that have accumulated
over the years, missing newline here and there or the extra { } around
statements. We can live with that and change it eventually when
modifying the surrounding code. I'm happy to apply cleanup patches that
are a byproduct of actually reading the code, but just running
checkpatch and generating patches is below the treshold.
