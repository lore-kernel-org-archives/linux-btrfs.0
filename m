From: Sunil Mushran <sunil.mushran@oracle.com>
Subject: Re: [PATCH 1/2] fs: add SEEK_HOLE and SEEK_DATA flags
Date: Thu, 21 Apr 2011 14:29:39 -0700
Message-ID: <4DB0A1C3.6050700@oracle.com>
References: <1303414954-3315-1-git-send-email-josef@redhat.com> <EB7F482C-0195-4C63-9436-17B417C8DCD7@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Cc: Josef Bacik <josef@redhat.com>, linux-kernel@vger.kernel.org,
	linux-btrfs@vger.kernel.org, linux-fsdevel@vger.kernel.org,
	hch@infradead.org
To: Theodore Tso <tytso@MIT.EDU>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <EB7F482C-0195-4C63-9436-17B417C8DCD7@mit.edu>
List-ID: <linux-btrfs.vger.kernel.org>

On 04/21/2011 01:45 PM, Theodore Tso wrote:
> On Apr 21, 2011, at 3:42 PM, Josef Bacik wrote:
>> +	case SEEK_DATA:
>> +	case SEEK_HOLE:
>> +		return -EINVAL;
>> 	}
>
> Maybe we should be returning EOPNOTSUPP?
>
> -- Ted

For SEEK_HOLE yes. But we could let the default SEEK_DATA be a null-op.
