Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-34-i6.italiaonline.it ([213.209.14.34]:45224 "EHLO
        libero.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1751167AbeC3QQz (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Fri, 30 Mar 2018 12:16:55 -0400
Reply-To: kreijack@inwind.it
Subject: Re: [RFC PATCH v3 0/7] btrfs-progs: Allow normal user to call
 "subvolume list/show"
To: Misono Tomohiro <misono.tomohiro@jp.fujitsu.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>, dsterba@suse.com
References: <a1089ceb-6642-0b20-9690-6cf961efe42e@jp.fujitsu.com>
 <7512a9b0-697d-8b5b-9f43-796f211fc5fd@libero.it>
 <b44aab69-db62-5adf-e191-9dc3f8cc69f9@jp.fujitsu.com>
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <73f21cbd-9be5-b419-2b49-2fc0ce060424@inwind.it>
Date: Fri, 30 Mar 2018 18:16:51 +0200
MIME-Version: 1.0
In-Reply-To: <b44aab69-db62-5adf-e191-9dc3f8cc69f9@jp.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 03/30/2018 06:46 AM, Misono Tomohiro wrote:
> [Un]fortunately, the stock "btrfs sub list" has the capability to show all the subvolumes, even the ones not mounted, so this can be entirely replaced by your API.

s/can be entirely/can't be entirely/

-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
