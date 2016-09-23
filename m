Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-yb0-f174.google.com ([209.85.213.174]:36108 "EHLO
        mail-yb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1034106AbcIWSTN (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 23 Sep 2016 14:19:13 -0400
Received: by mail-yb0-f174.google.com with SMTP id u125so69738040ybg.3
        for <linux-btrfs@vger.kernel.org>; Fri, 23 Sep 2016 11:19:13 -0700 (PDT)
Date: Fri, 23 Sep 2016 14:19:10 -0400
From: Vincent Batts <vbatts@hashbangbash.com>
To: dsterba@suse.cz, linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] btrfs-progs: subvolume verbose delete flag
Message-ID: <20160923181910.GA29785@bananaboat.hashbangbash.com>
References: <20160915191550.12371-1-vbatts@hashbangbash.com>
 <20160915191550.12371-2-vbatts@hashbangbash.com>
 <20160919174149.GP16983@twin.jikos.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
In-Reply-To: <20160919174149.GP16983@twin.jikos.cz>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 19/09/16 19:41 +0200, David Sterba wrote:
>Applied, thanks. I wonder where the original argument got lost. In the
>commit 2ed161bd281beca29feebebbc8c4227cc6e918c3 it to added to getopt
>but inside cmd_subvol_create. I'll fix it as well.

Not sure. I found it while investigating feasibility of adding a flag to
recursively delete subvolumes.
Which, do you have particular feelings about recursive deletes?
