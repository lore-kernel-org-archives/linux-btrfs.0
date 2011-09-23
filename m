From: Mathieu Chouquet-Stringer <mathieu@csetco.com>
Subject: Re: Btrfs bug with g38867a2 and a question
Date: Fri, 23 Sep 2011 19:16:47 +0200
Message-ID: <20110923171647.GA29400@kashmir>
References: <CALiWzOg8CQJF7OfMex1uJTa+doDZ8oufV1nAbos99Z4ev-+xKg@mail.gmail.com>
 <4E7B423C.2080007@redhat.com>
 <20110922182222.GA18449@kashmir>
 <4E7B85B3.6080106@redhat.com>
 <20110922193007.GA19088@kashmir>
 <20110922203213.GA19890@kashmir>
 <20110923125530.GA27417@kashmir>
 <4E7C9C72.4020109@redhat.com>
 <20110923153144.GA28744@kashmir>
 <4E7CA710.1060606@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: dave@jikos.cz, linux-btrfs@vger.kernel.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-btrfs-owner@vger.kernel.org>
In-Reply-To: <4E7CA710.1060606@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, Sep 23, 2011 at 11:34:40AM -0400, Josef Bacik wrote:
> Yeah this is a different problem that's fixed upstream, so reboot into
> your other newer kernel with -o clear_cache.  Thanks,

Ok I'm back in business now, thanks...

Now I'll try to understand why my pc sometimes hangs doing write IOs...
-- 
Mathieu Chouquet-Stringer                         mathieu@csetco.com
            The sun itself sees not till heaven clears.
	             -- William Shakespeare --
