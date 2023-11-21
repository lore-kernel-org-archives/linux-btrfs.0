Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 239B299;
	Tue, 21 Nov 2023 09:04:06 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
	id 94E9868AFE; Tue, 21 Nov 2023 18:04:03 +0100 (CET)
Date: Tue, 21 Nov 2023 18:04:03 +0100
From: Christoph Hellwig <hch@lst.de>
To: Johannes Thumshirn <johannes.thumshirn@wdc.com>
Cc: Chris Mason <clm@fb.com>, Josef Bacik <josef@toxicpanda.com>,
	David Sterba <dsterba@suse.com>, linux-btrfs@vger.kernel.org,
	linux-kernel@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
	Naohiro Aota <Naohiro.Aota@wdc.com>
Subject: Re: [PATCH 4/5] btrfs: use memset_page instead of opencoding it
Message-ID: <20231121170403.GD19695@lst.de>
References: <20231121-josef-generic-163-v1-0-049e37185841@wdc.com> <20231121-josef-generic-163-v1-4-049e37185841@wdc.com>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231121-josef-generic-163-v1-4-049e37185841@wdc.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
