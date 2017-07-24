Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:36430 "EHLO
        userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752336AbdGXPfV (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 24 Jul 2017 11:35:21 -0400
Subject: Re: [PATCH v3] Btrfs: add skeleton code for compression heuristic
To: dsterba@suse.cz, Adam Borowski <kilobyte@angband.pl>,
        Roman Mamedov <rm@romanrm.net>,
        Timofey Titovets <nefelim4ag@gmail.com>, linux-btrfs@vger.kernel.org
References: <20170717135258.15865-1-nefelim4ag@gmail.com>
 <20170717183035.GR2866@twin.jikos.cz>
 <f85d6fa7-4d1e-bfb8-7e64-ef02c468e42d@oracle.com>
 <20170721233749.5175d611@natsu> <20170721210027.3qoexc63zcbbnqxl@angband.pl>
 <20170724145356.GX2866@twin.jikos.cz>
From: Anand Jain <anand.jain@oracle.com>
Message-ID: <950a249d-9fb2-103a-0101-d37e6609ba8f@oracle.com>
Date: Mon, 24 Jul 2017 23:40:17 +0800
MIME-Version: 1.0
In-Reply-To: <20170724145356.GX2866@twin.jikos.cz>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>


> Eg. files that are already compressed would increase the cpu consumption
> with compress-force, while they'd be hopefully detected as
> incompressible with 'compress' and clever heuristics. So the NOCOMPRESS
> bit would better reflect the status of the file.

  current NOCOMPRESS is based on trial and error method and is more
  accurate than heuristic also loss of cpu power is only one time ?

  May be the only opportunity that heuristic can facilitate is at the
  logic to monitor and reset the NOCOMPRESS, as of now there is no
  such a logic.

Thanks, Anand
