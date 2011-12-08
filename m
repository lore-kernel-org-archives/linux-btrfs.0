From: Phillip Susi <psusi@cfl.rr.com>
Subject: Re: Cloning a Btrfs partition
Date: Thu, 08 Dec 2011 10:49:26 -0500
Message-ID: <4EE0DC86.9080005@cfl.rr.com>
References: <22fa7cb1-728a-4a3d-a51b-3ff54053380e@mail.placs.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Cc: Freddie Cash <fjwcash@gmail.com>, linux-btrfs@vger.kernel.org
To: BJ Quinn <bj@placs.net>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <22fa7cb1-728a-4a3d-a51b-3ff54053380e@mail.placs.net>
List-ID: <linux-btrfs.vger.kernel.org>

On 12/7/2011 1:49 PM, BJ Quinn wrote:
> What I need isn't really an equivalent "zfs send" -- my script can do
> that. As I remember, zfs send was pretty slow too in a scenario like
> this. What I need is to be able to clone a btrfs array somehow -- dd
> would be nice, but as I said I end up with the identical UUID
> problem. Is there a way to change the UUID of an array?

No, btrfs send is exactly what you need.  Using dd is slow because it 
copies unused blocks, and requires the source fs be unmounted and the 
destination be an empty partition.  rsync is slow because it can't take 
advantage of the btrfs tree to quickly locate the files (or parts of 
them) that have changed.  A btrfs send would solve all of these issues.
