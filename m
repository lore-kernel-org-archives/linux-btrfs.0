From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 3/6] direct-io: do not merge logically non-contiguous
	requests
Date: Fri, 21 May 2010 11:35:38 -0400
Message-ID: <20100521153538.GA1695@infradead.org>
References: <1274300694-8976-1-git-send-email-josef@redhat.com> <1274300694-8976-3-git-send-email-josef@redhat.com> <20100521152111.GB16049@infradead.org> <20100521153745.GP32248@dhcp231-156.rdu.redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Christoph Hellwig <hch@infradead.org>, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
	akpm@linux-foundation.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-fsdevel-owner@vger.kernel.org>
In-Reply-To: <20100521153745.GP32248@dhcp231-156.rdu.redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>

On Fri, May 21, 2010 at 11:37:45AM -0400, Josef Bacik wrote:
> So after I sent this I thought that maybe I could make that test _only_ if we
> provide submit_bio, that way it only affects btrfs and not everybody else, would
> you prefer I do something like that?  I will make the commit log a bit more
> verbose.  Thanks,

Again, I think it's not really worth optimizing for.  Just document very
clearly why it's there.

