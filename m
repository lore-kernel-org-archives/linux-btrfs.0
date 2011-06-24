From: Bob Copeland <me@bobcopeland.com>
Subject: Re: [PATCH 04/37] Remove unneeded version.h
	includes from fs/
Date: Fri, 24 Jun 2011 09:26:20 -0400
Message-ID: <20110624132620.GA5694@hash.lan>
References: <alpine.LNX.2.00.1106232344480.17688@swampdragon.chaosbits.net>
	<alpine.LNX.2.00.1106232358330.17688@swampdragon.chaosbits.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Cc: Chris Mason <chris.mason@oracle.com>, trivial@kernel.org,
	LKML <linux-kernel@vger.kernel.org>, linux-btrfs@vger.kernel.org,
	linux-karma-devel@lists.sourceforge.net
To: Jesper Juhl <jj@chaosbits.net>
Return-path: <linux-karma-devel-bounces@lists.sourceforge.net>
In-Reply-To: <alpine.LNX.2.00.1106232358330.17688@swampdragon.chaosbits.net>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/linux-karma-devel>,
	<mailto:linux-karma-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum_name=linux-karma-devel>
List-Post: <mailto:linux-karma-devel@lists.sourceforge.net>
List-Help: <mailto:linux-karma-devel-request@lists.sourceforge.net?subject=help>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/linux-karma-devel>,
	<mailto:linux-karma-devel-request@lists.sourceforge.net?subject=subscribe>
Errors-To: linux-karma-devel-bounces@lists.sourceforge.net
List-ID: <linux-btrfs.vger.kernel.org>

On Thu, Jun 23, 2011 at 11:59:32PM +0200, Jesper Juhl wrote:
> It was pointed out by 'make versioncheck' that some includes of
> linux/version.h were not needed in fs/ (fs/btrfs/ctree.h and
> fs/omfs/file.c).
> This patch removes them.
> 
> Signed-off-by: Jesper Juhl <jj@chaosbits.net>

Thanks, omfs part was leftover cruft from its time out-of-tree.

FWIW,
Acked-by: Bob Copeland <me@bobcopeland.com>
-- 
Bob Copeland %% www.bobcopeland.com


------------------------------------------------------------------------------
All the data continuously generated in your IT infrastructure contains a 
definitive record of customers, application performance, security 
threats, fraudulent activity and more. Splunk takes this data and makes 
sense of it. Business sense. IT sense. Common sense.. 
http://p.sf.net/sfu/splunk-d2d-c1
