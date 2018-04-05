Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:48529 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751259AbeDEOvY (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Thu, 5 Apr 2018 10:51:24 -0400
Date: Thu, 5 Apr 2018 16:48:54 +0200
From: David Sterba <dsterba@suse.cz>
To: Anand Jain <anand.jain@oracle.com>
Cc: dsterba@suse.cz, Nikolay Borisov <nborisov@suse.com>,
        linux-btrfs@vger.kernel.org
Subject: Re: [PATCH 2/8] btrfs: return required error from
 btrfs_check_super_csum
Message-ID: <20180405144854.GF2635@twin.jikos.cz>
Reply-To: dsterba@suse.cz
References: <20180326082742.9235-1-anand.jain@oracle.com>
 <20180326082742.9235-3-anand.jain@oracle.com>
 <4203fb44-3fd4-1e26-bf03-40d640de09af@suse.com>
 <20180327191636.GE30422@twin.jikos.cz>
 <ac89e7e0-dd67-d606-859d-dd784157e453@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <ac89e7e0-dd67-d606-859d-dd784157e453@oracle.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Wed, Mar 28, 2018 at 04:43:02AM +0800, Anand Jain wrote:
>   I understand reason behind string should not be split, but I
>   thought here will be an exception, as if you want to search
>   for the string you will still use "unsupported checksum algorithm"
>   which is still in one line.
>   About the grep not able to find the string which are split,
>   I look at it as fixing the wrong end of the problem. That is Grep
>   end problem being fixes at the c code end. Anyway as its kind of
>   linux general guidlines, I shall fix my patch.

It's not just grep, but any other similar line-oriented searching tool
or internal searches in editors or IDEs. Searching for fragments of the
string will likely lead to the result but splitting lines makes it
unnecessarily more difficult.
