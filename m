Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-32-i2.italiaonline.it ([212.48.25.202]:39779 "EHLO
	smtp-32.italiaonline.it" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753943AbbAES5i (ORCPT
	<rfc822;linux-btrfs@vger.kernel.org>); Mon, 5 Jan 2015 13:57:38 -0500
Message-ID: <54AADF21.7060303@inwind.it>
Date: Mon, 05 Jan 2015 19:59:45 +0100
From: Goffredo Baroncelli <kreijack@inwind.it>
Reply-To: kreijack@inwind.it
MIME-Version: 1.0
To: Lennart Poettering <lennart@poettering.net>, linux-btrfs@vger.kernel.org
Subject: Re: RFE: per-subvolume timestamp that is updated on every change
 to a subvolume
References: <20150105172754.GC19126@gardel-login>
In-Reply-To: <20150105172754.GC19126@gardel-login>
Content-Type: text/plain; charset=windows-1252
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2015-01-05 18:27, Lennart Poettering wrote:
> Heya!
> 
> I am looking for a nice way to query the overall last modification
> timestamp of a subvolume. i.e. the most recent mtime of *any* file or
> directory within a subvolume. Ideally, I think, there was a
> btrfs_timespec field for this in "struct btrfs_root_item", alas there
> isn't afaics. Any chance this can be added?
> 
> Or is there another workable way to query this value? Maybe determine
> it from the current generation of a subvolume or so? Is that tracked?
> Ideas?

Did you tried with "btrfs subvolume find-new" ?


> 
> Lennart
> --
> To unsubscribe from this list: send the line "unsubscribe linux-btrfs" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 


-- 
gpg @keyserver.linux.it: Goffredo Baroncelli <kreijackATinwind.it>
Key fingerprint BBF5 1610 0B64 DAC6 5F7D  17B2 0EDA 9B37 8B82 E0B5
