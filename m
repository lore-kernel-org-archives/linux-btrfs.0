From: Arne Jansen <sensille@gmx.net>
Subject: Re: Purpose of block reserves
Date: Fri, 10 Dec 2010 09:37:44 +0100
Message-ID: <4D01E6D8.3020105@gmx.net>
References: <4D0094AC.6090101@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: yanzheng@21cn.com
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4D0094AC.6090101@gmx.net>
List-ID: <linux-btrfs.vger.kernel.org>

Arne Jansen wrote:
> 
> while reading btrfs source code, I try to make sense of the various uses
> of block reserves. The working theory is as follows:

Since there have been no protests, I added this information to the wiki, section
"Code documentation".

--
Arne

> 
> 1. Every operation has to reserve upfront every single byte it needs to
>    complete its operation fully.
> 2. If an operation cannot determine how much space it will need, it has
>    to be able to cope with running out of space. Normally it does it by
>    inserting an orphan item, doing its work in multiple transactions and
>    removing the orphan item. The commits in between normally free up enough
>    space to continue the operation.
> 3. All other enospc situations are errors in program logic and should result
>    in BUG_ON.
> 
> It would be great of someone with a deeper knowledge could correct, expand
> or just confirm this.
> 
> Thanks,
> Arne
> --
