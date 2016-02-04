Return-Path: <linux-btrfs-owner@vger.kernel.org>
Received: from smtp-31.italiaonline.it ([212.48.25.159]:45049 "EHLO libero.it"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752826AbcBDRSC (ORCPT <rfc822;linux-btrfs@vger.kernel.org>);
	Thu, 4 Feb 2016 12:18:02 -0500
Reply-To: kreijack@inwind.it
Subject: Re: btrfs-progs and btrfs(8) inconsistencies
References: <CAM=f9=V-7hbjGLzWUxbynsoJdP-NexEoaTJ3GJJxn3gBYsW1BA@mail.gmail.com>
 <56B2AA51.80908@cn.fujitsu.com>
To: Qu Wenruo <quwenruo@cn.fujitsu.com>, Moviuro <moviuro@gmail.com>,
        linux-btrfs@vger.kernel.org
From: Goffredo Baroncelli <kreijack@inwind.it>
Message-ID: <56B387C6.9070505@inwind.it>
Date: Thu, 4 Feb 2016 18:17:58 +0100
MIME-Version: 1.0
In-Reply-To: <56B2AA51.80908@cn.fujitsu.com>
Content-Type: text/plain; charset=utf-8
Sender: linux-btrfs-owner@vger.kernel.org
List-ID: <linux-btrfs.vger.kernel.org>

On 2016-02-04 02:33, Qu Wenruo wrote:
> The idea itself makes a lot of sense.
> But I have at least two things to worry about:
> 
> 1) Old scripts backward compatibility
>     Especially xfstests. Maintainer will hate it a lot.
>     As we have changed it several times and broken existing test cases.
> 
>     Although personally I like to let all the backward compatibility
>     things go hell, but that's definitely not how things work. :(

we could change the name of the btrfs prog (like bfs or bctl  ?). 

If the command is called with the old name (btrfs) the old behavior is maintained; with the new name the new output is show if the specific sub command was updated; instead if the specific sub-command is not updated, the old output is show. 

We could allow a window of 1-year of transition where the new command will be in the alpha state where there is no any guarantee to be backward compatible, hoping that this time would be sufficient to reshape the output of all commands.

For the old command no update or enhancement should be allowed (with the exception of bugfix of course).

BR
G.Baroncelli


