Authentication-Results: smtp.subspace.kernel.org; dkim=none
Received: from vps.thesusis.net (vps.thesusis.net [IPv6:2600:1f18:60b9:2f00:6f85:14c6:952:bad3])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C602D10C
	for <linux-btrfs@vger.kernel.org>; Tue, 21 Nov 2023 07:28:34 -0800 (PST)
Received: by vps.thesusis.net (Postfix, from userid 1000)
	id 2F66D149E35; Tue, 21 Nov 2023 10:28:34 -0500 (EST)
From: Phillip Susi <phill@thesusis.net>
To: Andrei Borzenkov <arvidjaar@gmail.com>, kreijack@inwind.it
Cc: Qu Wenruo <quwenruo.btrfs@gmx.com>, Johannes Hirte
 <johannes.hirte@datenkhaos.de>, linux-btrfs@vger.kernel.org
Subject: Re: checksum errors but files are readable and no disk errors
In-Reply-To: <CAA91j0WK8XoZnZVhfJJP7akUMorvEJ9yunpgJDSTivah_VmPiQ@mail.gmail.com>
References: <6b6aafe0-811e-4619-91c3-36700e387cec@datenkhaos.de>
 <6a87d788-5f4c-4cb0-8351-233ab924129c@gmx.com>
 <87ttpgz3qp.fsf@vps.thesusis.net>
 <a288c71f-9e42-4448-9089-fc0e3dfa8abb@libero.it>
 <CAA91j0WK8XoZnZVhfJJP7akUMorvEJ9yunpgJDSTivah_VmPiQ@mail.gmail.com>
Date: Tue, 21 Nov 2023 10:28:34 -0500
Message-ID: <878r6r15y5.fsf@vps.thesusis.net>
Precedence: bulk
X-Mailing-List: linux-btrfs@vger.kernel.org
List-Id: <linux-btrfs.vger.kernel.org>
List-Subscribe: <mailto:linux-btrfs+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-btrfs+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain

Andrei Borzenkov <arvidjaar@gmail.com> writes:
> One wonders whether there is a kernel API to lock buffers to prevent
> uncontrolled write-out and to release them telling the kernel "now I'm
> done with it".

It would be the other way around: you tell the kernel to disallow user
space access to the buffer until the IO completes.  But that would
involve a lot of overhead updating page tables that would negate the
benefit of direct IO in the first place.
