Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from twin.jikos.cz ([89.185.236.188]:46966 "EHLO twin.jikos.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759929Ab2JYQrL (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 25 Oct 2012 12:47:11 -0400
Date: Thu, 25 Oct 2012 18:46:42 +0200
From: David Sterba <dave@jikos.cz>
To: Rock Lee <zimilo@code-trick.com>
Cc: linux-btrfs@vger.kernel.org
Subject: Re: [PATCH] [btrfs-progs] Modify parse_size to remove the strdup/free
Message-ID: <20121025164642.GM10679@twin.jikos.cz>
Reply-To: dave@jikos.cz
References: <CAMRmmpLkp58en6mikZ9MAYwoA_kkrZx+UNTifjXSw3=hELLZZw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <CAMRmmpLkp58en6mikZ9MAYwoA_kkrZx+UNTifjXSw3=hELLZZw@mail.gmail.com>
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On Tue, Oct 23, 2012 at 05:11:27PM +0800, Rock Lee wrote:
> Since the function atoi(l) series stop at the first non numeric chars,
> 
> So there's no need to strdup the original s and modify s[len-1] = '\0'

This change is superseded and contained in Goffredos patches which I
prefer for inclusion as they do more extensive updates.

thanks anyway,
david
