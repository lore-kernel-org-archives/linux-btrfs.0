Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:46638 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753060Ab2JYQRj (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Oct 2012 12:17:39 -0400
Date: Thu, 25 Oct 2012 18:13:55 +0200
From: David Sterba <dave@jikos.cz>
To: Goffredo Baroncelli <kreijack@gmail.com>
Cc: linux-btrfs@vger.kernel.org, Stefan Behrens <sbehrens@giantdisaster.de>,
        Wang Sheng-Hui <shhuiw@gmail.com>,
        Goffredo Baroncelli <kreijack@inwind.it>
Subject: Re: [PATCH 5/5] Update the man page with the new prefixes.
Message-ID: <20121025161355.GJ10679@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <1351014715-5727-1-git-send-email-kreijack@inwind.com>
 <1351014715-5727-6-git-send-email-kreijack@inwind.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1351014715-5727-6-git-send-email-kreijack@inwind.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

Hi,

one minor typo

On Tue, Oct 23, 2012 at 07:51:55PM +0200, Goffredo Baroncelli wrote:
> --- a/man/btrfs.8.in
> +++ b/man/btrfs.8.in
> @@ -184,6 +184,9 @@ defragment operations.
>  
>  \fB-t size\fP defragment only files at least \fIsize\fR bytes big
>  
> +For \fBstart\fP, \fBlen\fP, \fBsize\fP it is possible to append a prefix
                                                                     ^^^^^^
suffix

> +like \fBk\fP for 1 KBytes, \fBm\fP for 1 MBytes...
> +

david
