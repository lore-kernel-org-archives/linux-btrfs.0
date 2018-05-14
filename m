Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:33604 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751364AbeENJqf (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
        Mon, 14 May 2018 05:46:35 -0400
Subject: Re: [PATCH] btrfs: inode: Don't compress if NODATASUM or NODATACOW
 set
To: Roman Mamedov <rm@romanrm.net>
Cc: Qu Wenruo <wqu@suse.com>, linux-btrfs@vger.kernel.org,
        David Sterba <dsterba@suse.cz>
References: <20180514070210.27047-1-wqu@suse.com>
 <90871596-c030-930b-57ad-7db63b4f579d@suse.com>
 <20180514132004.3afec300@natsu>
 <ea90a7da-a055-6879-e64f-f0f3bca81a23@suse.com>
 <20180514143933.60b3bb76@natsu>
From: Nikolay Borisov <nborisov@suse.com>
Message-ID: <a430d610-8d97-fb92-551b-387b83ecff38@suse.com>
Date: Mon, 14 May 2018 12:46:31 +0300
MIME-Version: 1.0
In-Reply-To: <20180514143933.60b3bb76@natsu>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

[Adding David to CC]

On 14.05.2018 12:39, Roman Mamedov wrote:
> On Mon, 14 May 2018 11:36:26 +0300
> Nikolay Borisov <nborisov@suse.com> wrote:
> 
>> So what made you have these expectation, is it codified somewhere
>> (docs/man pages etc)? I'm fine with that semantics IF this is what
>> people expect.
> 
> "Compression ...does not work for NOCOW files":
> https://btrfs.wiki.kernel.org/index.php/Compression
> 
> The mount options man page does not say that the NOCOW attribute of files will
> be disregarded with compress-force.  It only mentions interaction with the
> nodatacow and nodatasum mount options. So I'd expect the attribute to still
> work and prevent compression of NOCOW files.

I wouldn't say this is very clear, it needs to be stated explicitly.

> 
>> Now the question is why people grew up to have this expectation and not the
>> other way round? IMO force_compress should really disregard everything else
> 
> Both are knobs that the user needs to explicitly set, the difference is that
> the +C attribute is fine-grained and the mount option is global. If they are
> set by the user to conflicting values, it seems more useful to have the
> fine-grained control override the global one, not the other way round.

This is valid reasoning but so is mine. So I'd like to have some rules
on that matter such that in the future things will have consistent
semantics. Obviously in this case the "local options trump global ones"
seems to be prevalent. I don't have problem with that but this should
codified somewhere.


David, what's your take on that. Where do you think will be the best
place to say that local, per-inode options take precedence over global ones?

> 
