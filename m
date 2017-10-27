Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:45610 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751472AbdJ0Qzr (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 27 Oct 2017 12:55:47 -0400
Received: from relay1.suse.de (charybdis-ext.suse.de [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id F03CFAAA3
        for <linux-btrfs@vger.kernel.org>; Fri, 27 Oct 2017 16:55:45 +0000 (UTC)
Date: Fri, 27 Oct 2017 18:53:57 +0200
From: David Sterba <dsterba@suse.cz>
To: Qu Wenruo <wqu@suse.com>
Cc: linux-btrfs@vger.kernel.org, dsterba@suse.cz
Subject: Re: [PATCH v3 1/2] btrfs-progs: test/common: Introduce
 run_mustfail_stdout and enhance prepare_test_dev
Message-ID: <20171027165357.GM3521@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20171027005324.17950-1-wqu@suse.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20171027005324.17950-1-wqu@suse.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Oct 27, 2017 at 08:53:23AM +0800, Qu Wenruo wrote:
> Introduce a new function, run_mustfail_stdout(), which is similar to
> run_mustfail(), with extra output redirection.
> Also this new run_mustfail_stdout() doesn't set pipefail and use
> temporary file to catch the output.
> So it doesn't support command with pipeline.
> 
> Also enhance prepare_test_dev() to truncates the file even it already
> exists.
> So test device size will be reset each time prepare_test_dev() get
> called.

That's a completely unrelated change to the above and should be also
split, please.
