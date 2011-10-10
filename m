From: Kai Krakow <hurikhan77+btrfs@gmail.com>
Subject: Re: Corrupt file in subvolume
Date: Mon, 10 Oct 2011 13:55:12 +0200
Message-ID: <8j2bm8-ob9.ln1@hurikhan.ath.cx>
References: <loom.20111010T040355-185@post.gmane.org> <20111010103723.GE17912@twin.jikos.cz>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"
To: linux-btrfs@vger.kernel.org
Return-path: <linux-btrfs-owner@vger.kernel.org>
List-ID: <linux-btrfs.vger.kernel.org>

David Sterba wrote:

>> Then I could mount the /home subvolume.
>>
>> I also found the corrupted file
>>? -????????? ? ?   ?        ?            ? 13.4.4.40.js
> 
> Chromium cache? Somebody recently reported a problem there. I wonder
> what this browser does to the filesystem ... :)

If you meant me by "someone": No, my problem was not related to chromium 
usage - the problems only raised there because of a previous "cp --reflink" 
issue while I continued browsing. ;-)

So it is pure coincidence because browser caches are a probable destination 
for write access while my system came to a complete halt due to a browsing-
unrelated file operation (cp --reflink).

Regards,
Kai

