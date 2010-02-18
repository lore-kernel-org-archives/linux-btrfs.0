From: TARUISI Hiroaki <taruishi.hiroak@jp.fujitsu.com>
Subject: Re: [PATCH 1/2 V2] btrfs, a new tool to manage a btrfs filesystem;
 source code
Date: Thu, 18 Feb 2010 09:54:38 +0900
Message-ID: <4B7C8FCE.6090706@jp.fujitsu.com>
References: <201002172102.30645.kreijack@inwind.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: linux-btrfs@vger.kernel.org
To: kreijack@gmail.com
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <201002172102.30645.kreijack@inwind.it>
List-ID: <linux-btrfs.vger.kernel.org>

Hi,
It's a cool utility with tidy source code.
At my first glance, there's typo, a question and an impression.

 - There's no "<source>" in usage of utility.
 - will occupe -> will occupy
   (usage of utility : "btrfs resize")
 - Is specifying a target device of resizing isn't public
   even in your utility?
 - I felt somehow confusing with the short commands.
   It's not easy to associate it from its command.

Regards,
taruisi

(2010/02/18 5:02), Goffredo Baroncelli wrote:
> This is the source code of btrfs.c.
> The main changes from my previous patch are:
> - Rearranged the short command in order to avoid conflicts
> - Renamed the 'create' verb is 'subvolume'
> - Rearranged the parsing code, which now is integrated in the help in order to avoid mismatch
> 
> BR
> G.Baroncelli
> 
 - snip -

