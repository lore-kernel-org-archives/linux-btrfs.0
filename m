From: Theodore Tso <tytso@MIT.EDU>
Subject: Re: [PATCH 1/2] fs: add SEEK_HOLE and SEEK_DATA flags
Date: Thu, 21 Apr 2011 16:45:54 -0400
Message-ID: <EB7F482C-0195-4C63-9436-17B417C8DCD7@mit.edu>
References: <1303414954-3315-1-git-send-email-josef@redhat.com>
Mime-Version: 1.0 (Apple Message framework v1084)
Content-Type: text/plain; charset=us-ascii
Cc: linux-kernel@vger.kernel.org, linux-btrfs@vger.kernel.org,
	linux-fsdevel@vger.kernel.org, hch@infradead.org
To: Josef Bacik <josef@redhat.com>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1303414954-3315-1-git-send-email-josef@redhat.com>
List-ID: <linux-btrfs.vger.kernel.org>


On Apr 21, 2011, at 3:42 PM, Josef Bacik wrote:

> +	case SEEK_DATA:
> +	case SEEK_HOLE:
> +		return -EINVAL;
> 	}

Maybe we should be returning EOPNOTSUPP?

-- Ted
