Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp89.iad3a.emailsrvr.com ([173.203.187.89]:41985 "EHLO
        smtp89.iad3a.emailsrvr.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752689AbdLDONx (ORCPT
        <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 4 Dec 2017 09:13:53 -0500
Subject: Re: command to get quota limit
To: ST <smntov@gmail.com>, linux-btrfs@vger.kernel.org
References: <1512389667.1707.109.camel@gmail.com>
From: Marat Khalili <mkh@rqc.ru>
Message-ID: <2b565a84-33a0-3fd1-559b-56bc32bf8a40@rqc.ru>
Date: Mon, 4 Dec 2017 17:13:53 +0300
MIME-Version: 1.0
In-Reply-To: <1512389667.1707.109.camel@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

AFAIK you don't need subvolume id, `btrfs qgroup show -ref 
/path/to/subvolume` shows necessary qgroup for me. Separating value you 
need is more involved:

> btrfs qgroup show -ref --raw /path/to/subvolume | tail -n +3 | tr -s ' 
> ' | cut -d ' ' -f 4
Not sure how robust is this though.

--

With Best Regards,
Marat Khalili

