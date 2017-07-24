Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:36108 "EHLO
        mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753526AbdGXPCj (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Jul 2017 11:02:39 -0400
Received: by mail-qk0-f196.google.com with SMTP id d136so10141335qkg.3
        for <linux-btrfs@vger.kernel.org>; Mon, 24 Jul 2017 08:02:39 -0700 (PDT)
Date: Mon, 24 Jul 2017 11:02:37 -0400
From: Josef Bacik <josef@toxicpanda.com>
To: Timofey Titovets <nefelim4ag@gmail.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 0/3] Btrfs: populate heuristic with detection logic
Message-ID: <20170724150236.GE9406@destiny>
References: <20170724113708.18088-1-nefelim4ag@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20170724113708.18088-1-nefelim4ag@gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Mon, Jul 24, 2017 at 02:37:05PM +0300, Timofey Titovets wrote:
> Based on kdave for-next
> As heuristic skeleton already merged
> Populate heuristic with basic code that:
> 1. Collect sample from input data
> 2. Calculate byte set for sample
>    For detect easily compressible data
> 3. Calculate byte core set size
>    For detect easily and not compressible data
> 
> Timofey Titovets (3):
>   Btrfs: heuristic add simple sampling logic
>   Btrfs: heuristic add byte set calculation
>   Btrfs: heuristic add byte core set calculation
> 
>  fs/btrfs/compression.c | 111 ++++++++++++++++++++++++++++++++++++++++++++++++-
>  fs/btrfs/compression.h |  14 +++++++
>  2 files changed, 123 insertions(+), 2 deletions(-)
> 

Overall these look fine, I'd like more verbose changelogs to describe in more
detail the heuristic you are adding.  I had to go back and work out what you
were doing a few times because it wasn't clear what each patch was doing.
Thanks,

Josef
